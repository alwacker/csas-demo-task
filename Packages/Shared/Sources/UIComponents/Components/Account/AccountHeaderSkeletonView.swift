import SharedExtensions
import SwiftUI

public struct AccountHeaderSkeletonView: View {
    public init() {}

    public var body: some View {
        AccountHeaderView(
            name: "Placeholder account name",
            status: .active,
            balance: FormattedAmount(integer: "000 000,", fraction: "00", currency: " Kč", text: "000 000,00 Kč", isNegative: false)
        )
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
