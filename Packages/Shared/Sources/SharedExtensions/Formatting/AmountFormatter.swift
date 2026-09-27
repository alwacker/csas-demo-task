import Foundation

public protocol AmountFormatter: Sendable {
    func format(_ value: Decimal, currencyCode: String) -> FormattedAmount
}

public struct AmountFormatterImp: AmountFormatter {
    private let locale: Locale

    public init(locale: Locale = Locale(identifier: "cs_CZ")) {
        self.locale = locale
    }

    public func format(_ value: Decimal, currencyCode: String) -> FormattedAmount {
        let text = value.formatted(.currency(code: currencyCode).locale(locale))
        let isNegative = value < 0

        guard let separator = locale.decimalSeparator, let range = text.range(of: separator) else {
            return FormattedAmount(integer: text, fraction: "", currency: "", text: text, isNegative: isNegative)
        }

        let rest = text[range.upperBound...]
        let fraction = String(rest.prefix(while: \.isNumber))

        return FormattedAmount(
            integer: String(text[..<range.upperBound]),
            fraction: fraction,
            currency: String(rest.dropFirst(fraction.count)),
            text: text,
            isNegative: isNegative
        )
    }
}
