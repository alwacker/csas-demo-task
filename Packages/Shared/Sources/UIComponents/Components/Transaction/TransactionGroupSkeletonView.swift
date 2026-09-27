import Localization
import SwiftUI

public struct TransactionGroupSkeletonView: View {
    public init() {}

    public var body: some View {
        TransactionGroupView(group: Self.placeholder)
            .redacted(reason: .placeholder)
            .accessibilityElement()
            .accessibilityLabel(Localization.Common.loadingTransactions)
    }

    private static let placeholder = TransactionGroup(
        title: "Placeholder month",
        rows: (0 ..< 3).map { index in
            TransactionRow(
                id: index,
                title: "Counterparty name",
                message: nil,
                date: "01. 01. 2000",
                category: "Category",
                amount: "-1 000,00 Kč",
                direction: .outgoing
            )
        }
    )
}
