public final class FormatterContainer {
    public init() {}

    public func makeAmountFormatter() -> AmountFormatter {
        AmountFormatterImp()
    }

    public func makeAccountNumberFormatter() -> AccountNumberFormatter {
        AccountNumberFormatterImp()
    }

    public func makeDateTextFormatter() -> DateTextFormatter {
        DateTextFormatterImp()
    }
}
