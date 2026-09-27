import Foundation
import Synchronization

final class URLProtocolStub: URLProtocol {
    struct Stub: Sendable {
        let statusCode: Int
        let data: Data
    }

    private static let state = Mutex<(stub: Stub?, requests: [URLRequest])>((nil, []))

    static var requests: [URLRequest] {
        state.withLock { $0.requests }
    }

    static func stub(statusCode: Int, data: Data) {
        state.withLock { $0 = (Stub(statusCode: statusCode, data: data), []) }
    }

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let stub = Self.state.withLock { state in
            state.requests.append(request)
            return state.stub
        }

        guard
            let stub,
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: stub.statusCode, httpVersion: nil, headerFields: nil)
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: stub.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
