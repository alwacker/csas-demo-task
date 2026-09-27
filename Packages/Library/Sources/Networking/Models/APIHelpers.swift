import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: any Sendable]
public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>

public extension HTTPCodes {
    static let success = 200 ..< 300
}
