import Foundation

public extension URLSession {
    static let `default`: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
}
