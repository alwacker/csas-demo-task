import Foundation
import Testing
@testable import Models

@Suite("DomainErrorConverter")
struct DomainErrorConverterTests {
    private static let body = Data(#"{"status":500,"errors":[{"error":"INTERNAL_SERVER_ERROR"}]}"#.utf8)

    private static let cases: [(any Error, DomainError)] = [
        (APIError.error(statusCode: 404, data: Data()), .notFound),
        (APIError.error(statusCode: 500, data: body), .error(data: body)),
        (APIError.missedAPIKey, .unknown),
        (APIError.invalidURL, .unknown),
        (APIError.unexpectedResponse, .unknown),
        (URLError(.notConnectedToInternet), .offline),
        (URLError(.networkConnectionLost), .offline),
        (URLError(.cancelled), .cancelled),
        (CancellationError(), .cancelled),
        (URLError(.badServerResponse), .unknown)
    ]

    @Test("maps infrastructure errors to DomainError", arguments: cases)
    func test_givenError_whenConvert_thenMapsToDomainError(error: any Error, expected: DomainError) {
        // arrange
        let sut = DomainErrorConverterImp()

        // act
        let result = sut.convert(error: error)

        // assert
        #expect(result == expected)
    }
}
