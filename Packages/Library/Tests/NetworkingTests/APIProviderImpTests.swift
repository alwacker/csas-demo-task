import Foundation
import Models
import Testing
@testable import Networking

@Suite("APIProviderImp", .serialized)
struct APIProviderImpTests {
    private struct Response: Decodable, Sendable, Equatable {
        let value: Int
    }

    private static let baseURL = "https://example.com/api"

    @Test("GET puts sorted parameters into the query and the key into the header")
    func test_givenGet_whenRequest_thenURLAndHeaders() async throws {
        // arrange
        URLProtocolStub.stub(statusCode: 200, data: Data(#"{"value":1}"#.utf8))
        let sut = makeSUT()

        // act
        let _: Response = try await sut.request(
            endpoint: .accountList,
            method: .get,
            parameters: ["size": 50, "page": 0],
            headers: ["WEB-API-key": "other"]
        )

        // assert
        let request = try #require(URLProtocolStub.requests.first)
        #expect(request.httpMethod == "GET")
        #expect(request.url?.absoluteString == "https://example.com/api/transparentAccounts?page=0&size=50")
        #expect(request.value(forHTTPHeaderField: "WEB-API-key") == "key")
    }

    @Test("a 2xx response is decoded")
    func test_givenSuccess_whenRequest_thenDecoded() async throws {
        // arrange
        URLProtocolStub.stub(statusCode: 200, data: Data(#"{"value":42}"#.utf8))

        // act
        let result: Response = try await makeSUT().request(endpoint: .accountDetail(id: "000000-2906478309"))

        // assert
        #expect(result == Response(value: 42))
        #expect(URLProtocolStub.requests.first?.url?.path == "/api/transparentAccounts/000000-2906478309")
    }

    @Test("a non-2xx response throws with its status code and body")
    func test_givenErrorStatus_whenRequest_thenAPIError() async {
        // arrange
        let body = Data(#"{"status":412,"errors":[{"error":"KEY_NOT_FOUND"}]}"#.utf8)
        URLProtocolStub.stub(statusCode: 412, data: body)

        // act & assert
        await #expect(throws: APIError.error(statusCode: 412, data: body)) {
            let _: Response = try await makeSUT().request(endpoint: .accountList)
        }
    }

    @Test("an undecodable body throws a decoding error")
    func test_givenBadBody_whenRequest_thenDecodingError() async {
        // arrange
        URLProtocolStub.stub(statusCode: 200, data: Data("not json".utf8))

        // act & assert
        await #expect(throws: DecodingError.self) {
            let _: Response = try await makeSUT().request(endpoint: .accountList)
        }
    }

    @Test("no base URL throws before any request is sent")
    func test_givenNoBaseURL_whenRequest_thenInvalidURL() async {
        // arrange
        URLProtocolStub.stub(statusCode: 200, data: Data())
        let sut = APIProviderImp(session: URLProtocolStub.makeSession(), baseURL: nil, apiKey: "key")

        // act & assert
        await #expect(throws: APIError.invalidURL) {
            let _: Response = try await sut.request(endpoint: .accountList)
        }
        #expect(URLProtocolStub.requests.isEmpty)
    }

    @Test("no API key throws before any request is sent")
    func test_givenNoAPIKey_whenRequest_thenMissedAPIKey() async {
        // arrange
        URLProtocolStub.stub(statusCode: 200, data: Data())
        let sut = APIProviderImp(session: URLProtocolStub.makeSession(), baseURL: Self.baseURL, apiKey: nil)

        // act & assert
        await #expect(throws: APIError.missedAPIKey) {
            let _: Response = try await sut.request(endpoint: .accountList)
        }
        #expect(URLProtocolStub.requests.isEmpty)
    }

    private func makeSUT() -> APIProviderImp {
        APIProviderImp(session: URLProtocolStub.makeSession(), baseURL: Self.baseURL, apiKey: "key")
    }
}
