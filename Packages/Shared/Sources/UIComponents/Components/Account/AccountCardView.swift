import Localization
import SharedExtensions
import SwiftUI

public struct AccountCardView: View {
    private let name: String
    private let status: AccountStatus
    private let balance: FormattedAmount
    private let purpose: String?
    private let accountNumber: String

    public init(
        name: String,
        status: AccountStatus,
        balance: FormattedAmount,
        purpose: String?,
        accountNumber: String
    ) {
        self.name = name
        self.status = status
        self.balance = balance
        self.purpose = purpose
        self.accountNumber = accountNumber
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            StatusBarView(status: status)

            VStack(alignment: .leading, spacing: .zero) {
                info
                footer
            }
            .padding(.horizontal, .screenMargin)
            .padding(.top, Layout.paddingTop)
            .padding(.bottom, Layout.paddingBottom)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Palette.backgroundElevated)
        .clipShape(.rect(cornerRadius: .cardRadius))
        .cardShadow()
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(name)
                .font(.headline)
                .foregroundStyle(Color.Palette.textPrimary)
                .lineLimit(2)

            StatusChipView(status: status)
                .padding(.top, Layout.nameToChip)

            AmountView(balance)
                .padding(.top, Layout.chipToAmount)

            if let purpose {
                Text(purpose)
                    .font(.subheadline)
                    .foregroundStyle(Color.Palette.textSecondary)
                    .padding(.top, Layout.amountToPurpose)
            }

            SeparatorView()
                .padding(.top, Layout.purposeToSeparator)
        }
        .accessibilityElement(children: .combine)
    }

    private var footer: some View {
        HStack(spacing: Layout.footerSpacing) {
            Text(accountNumber)
                .font(.caption.monospaced())
                .tracking(Layout.numberTracking)
                .foregroundStyle(Color.Palette.textSecondary)

            Spacer(minLength: .zero)

            CopyButton(value: accountNumber, size: .regular, accessibilityLabel: Localization.Common.copyAccountNumber)
        }
        .padding(.top, Layout.separatorToNumber)
    }
}

private enum Layout {
    static let paddingTop: CGFloat = 14
    static let paddingBottom: CGFloat = 12
    static let nameToChip: CGFloat = 6
    static let chipToAmount: CGFloat = 10
    static let amountToPurpose: CGFloat = 2
    static let purposeToSeparator: CGFloat = 12
    static let separatorToNumber: CGFloat = 10
    static let footerSpacing: CGFloat = 8
    static let numberTracking: CGFloat = 0.2
}
