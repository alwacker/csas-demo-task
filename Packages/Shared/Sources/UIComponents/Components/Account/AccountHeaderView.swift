import SharedExtensions
import SwiftUI

public struct AccountHeaderView: View {
    private let name: String
    private let status: AccountStatus
    private let balance: FormattedAmount

    public init(name: String, status: AccountStatus, balance: FormattedAmount) {
        self.name = name
        self.status = status
        self.balance = balance
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            StatusBarView(status: status)

            VStack(alignment: .leading, spacing: .zero) {
                Text(name)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.Palette.textPrimary)
                    .accessibilityAddTraits(.isHeader)

                StatusChipView(status: status)
                    .padding(.top, Layout.nameToChip)

                AmountView(balance)
                    .padding(.top, Layout.chipToAmount)
            }
            .padding(.horizontal, Layout.padding)
            .padding(.top, Layout.padding)
            .padding(.bottom, Layout.paddingBottom)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Palette.backgroundElevated)
        .clipShape(.rect(cornerRadius: .cardRadiusLarge))
        .cardShadow()
    }
}

private enum Layout {
    static let padding: CGFloat = 18
    static let paddingBottom: CGFloat = 20
    static let nameToChip: CGFloat = 6
    static let chipToAmount: CGFloat = 10
}
