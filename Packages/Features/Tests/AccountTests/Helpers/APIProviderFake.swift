import Models
import Networking

actor APIProviderFake: APIProvider {
    struct Request: Equatable {
        let endpoint: APIEndpoint
        let method: APIMethod
        let parameters: [String: String]
    }

    private(set) var requests: [Request] = []
    private let response: (any Sendable)?
    private let error: (any Error)?

    init(response: any Sendable) {
        self.response = response
        self.error = nil
    }

    init(error: any Error) {
        self.response = nil
        self.error = error
    }

    func request<T: Decodable & Sendable>(
        endpoint: APIEndpoint,
        method: APIMethod,
        parameters: Parameters?,
        headers: HTTPHeaders
    ) async throws -> T {
        requests.append(Request(
            endpoint: endpoint,
            method: method,
            parameters: (parameters ?? [:]).mapValues { "\($0)" }
        ))
        if let error { throw error }
        guard let response = response as? T else { throw APIError.unexpectedResponse }
        return response
    }
}

final class DomainErrorConverterStub: DomainErrorConverter {
    func convert(error: any Error) -> DomainError {
        .offline
    }
}
