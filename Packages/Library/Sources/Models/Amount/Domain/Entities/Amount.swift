import Foundation

public struct Amount: Equatable, Sendable {
    public let value: Decimal
    public let currency: Currency

    public init(value: Decimal, currency: Currency) {
        self.value = value
        self.currency = currency
    }
}
