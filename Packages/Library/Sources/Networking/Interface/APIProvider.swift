import Foundation
import os

import Models

public protocol APIProvider: Sendable {
    func request<T: Decodable & Sendable>(
        endpoint: APIEndpoint,
        method: APIMethod,
        parameters: Parameters?,
        headers: HTTPHeaders
    ) async throws -> T
}

public extension APIProvider {
    func request<T: Decodable & Sendable>(
        endpoint: APIEndpoint,
        method: APIMethod = .get
    ) async throws -> T {
        try await request(endpoint: endpoint, method: method, parameters: nil, headers: [:])
    }

    func request<T: Decodable & Sendable>(
        endpoint: APIEndpoint,
        method: APIMethod,
        parameters: Parameters?
    ) async throws -> T {
        try await request(endpoint: endpoint, method: method, parameters: parameters, headers: [:])
    }
}

public final class APIProviderImp: APIProvider {
    private let session: URLSession
    private let baseURL: String?
    private let apiKey: String?
    private let decoder = JSONDecoder.makeAPIDecoder()
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "csas-demo-task",
        category: "Networking"
    )

    public init(
        session: URLSession = .default,
        baseURL: String? = Environment.baseURL,
        apiKey: String? = Environment.apiKey
    ) {
        self.session = session
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    public func request<T: Decodable & Sendable>(
        endpoint: APIEndpoint,
        method: APIMethod,
        parameters: Parameters?,
        headers: HTTPHeaders
    ) async throws -> T {
        let request = try makeRequest(endpoint: endpoint, method: method, parameters: parameters, headers: headers)
        logger.debug("🚕 \(method.rawValue, privacy: .private) \(request.url?.absoluteString ?? "", privacy: .private)")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unexpectedResponse
            }
            guard HTTPCodes.success.contains(httpResponse.statusCode) else {
                throw APIError.error(statusCode: httpResponse.statusCode, data: data)
            }
            logger.debug(
                """
                ✅ \(httpResponse.statusCode, privacy: .private)
                Response:
                \(endpoint.path, privacy: .public),
                \(String(data: data, encoding: .utf8) as NSObject?, privacy: .private)
                """
            )
            return try decoder.decode(T.self, from: data)
        } catch {
            if let error = error as? APIError {
                logger.error("🚩 \(endpoint.path, privacy: .private): \(String(describing: error.errorDescription), privacy: .private)")
            }
            throw error
        }
    }

    private func makeRequest(
        endpoint: APIEndpoint,
        method: APIMethod,
        parameters: Parameters?,
        headers: HTTPHeaders
    ) throws -> URLRequest {
        guard
            let baseURL,
            var components = URLComponents(string: baseURL + endpoint.path)
        else {
            throw APIError.invalidURL
        }

        var body: Data?
        switch method {
        case .get:
            if let parameters, !parameters.isEmpty {
                components.queryItems = parameters
                    .sorted { $0.key < $1.key }
                    .map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            }
        case .post:
            if let parameters {
                body = try JSONSerialization.data(withJSONObject: parameters)
            }
        }

        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.allHTTPHeaderFields = try makeHeaders(headers)
        return request
    }

    private func makeHeaders(_ headers: HTTPHeaders) throws -> HTTPHeaders {
        guard let apiKey else { throw APIError.missedAPIKey }
        var result = ["WEB-API-key": apiKey]
        result.merge(headers) { current, _ in current }
        return result
    }
}

