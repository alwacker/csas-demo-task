import SharedExtensions
import SwiftUI

public struct AmountView: View {
    private let amount: FormattedAmount

    public init(_ amount: FormattedAmount) {
        self.amount = amount
    }

    public var body: some View {
        Text("\(integerText)\(fractionText)\(currencyText)")
            .monospacedDigit()
            .foregroundStyle(amount.isNegative ? Color.Palette.amountNegative : Color.Palette.textPrimary)
            .accessibilityElement()
            .accessibilityLabel(amount.text)
    }

    private var integerText: Text {
        Text(amount.integer)
            .font(.title.weight(.bold))
    }

    private var fractionText: Text {
        Text(amount.fraction)
            .font(.callout.weight(.bold))
            .baselineOffset(Layout.fractionOffset)
    }

    private var currencyText: Text {
        Text(amount.currency)
            .font(.headline)
    }
}

private enum Layout {
    static let fractionOffset: CGFloat = 8
}
