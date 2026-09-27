import Foundation

public enum APIError: Error, Equatable, Sendable {
    case invalidURL
    case missedAPIKey
    case error(statusCode: Int, data: Data)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case let .error(statusCode, data):
            return "Unexpected HTTP code: \(statusCode), data: \(String(data: data, encoding: .utf8) ?? "Unknown data")"
        case .unexpectedResponse:
            return "Unexpected response from the server"
        case .missedAPIKey:
            return "Missed API Key on your environment, please check the Readme"
        }
    }
}
