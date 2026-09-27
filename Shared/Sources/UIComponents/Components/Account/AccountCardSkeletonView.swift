import SharedExtensions
import SwiftUI

public struct AccountCardSkeletonView: View {
    public init() {}

    public var body: some View {
        AccountCardView(
            name: "Placeholder account name",
            status: .active,
            balance: FormattedAmount(integer: "000 000,", fraction: "00", currency: " Kč", text: "000 000,00 Kč", isNegative: false),
            purpose: "Placeholder purpose",
            accountNumber: "0000000000/0000"
        )
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
