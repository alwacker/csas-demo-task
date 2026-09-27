import Foundation

public protocol DomainErrorConverter: AnyObject, Sendable {
    func convert(error: any Error) -> DomainError
}

final class DomainErrorConverterImp: DomainErrorConverter {
    private static let offlineCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .dataNotAllowed
    ]

    func convert(error: any Error) -> DomainError {
        switch error {
        case let error as APIError:
            convert(apiError: error)
        case let error as URLError where error.code == .cancelled:
            .cancelled
        case let error as URLError where Self.offlineCodes.contains(error.code):
            .offline
        case is CancellationError:
            .cancelled
        default:
            .unknown
        }
    }

    private func convert(apiError: APIError) -> DomainError {
        switch apiError {
        case .error(statusCode: 404, _):
            .notFound
        case let .error(_, data):
            .error(data: data)
        case .invalidURL, .missedAPIKey, .unexpectedResponse:
            .unknown
        }
    }
}
