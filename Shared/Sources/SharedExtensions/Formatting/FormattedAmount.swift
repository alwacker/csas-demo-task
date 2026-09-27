public struct FormattedAmount: Equatable, Sendable {
    public let integer: String
    public let fraction: String
    public let currency: String
    public let text: String
    public let isNegative: Bool

    public init(integer: String, fraction: String, currency: String, text: String, isNegative: Bool) {
        self.integer = integer
        self.fraction = fraction
        self.currency = currency
        self.text = text
        self.isNegative = isNegative
    }
}
