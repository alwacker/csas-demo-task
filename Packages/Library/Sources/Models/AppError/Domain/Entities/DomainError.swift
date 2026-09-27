import Foundation

public enum DomainError: Error, Equatable, Sendable {
    case offline
    case notFound
    case error(data: Data)
    case cancelled
    case unknown
}
