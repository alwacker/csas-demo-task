import Foundation

public protocol AmountConverter: Sendable {
    func convert(value: Decimal, currency: String?) -> Amount
}

struct AmountConverterImp: AmountConverter {
    func convert(value: Decimal, currency: String?) -> Amount {
        Amount(value: value, currency: currency.map(Currency.init(code:)) ?? .czk)
    }
}
