import SwiftUI

public struct TransactionGroupView: View {
    private let group: TransactionGroup

    public init(group: TransactionGroup) {
        self.group = group
    }

    public var body: some View {
        CardSection(
            title: group.title,
            titleFont: .title3.weight(.bold),
            items: group.rows,
            separatorInset: TransactionRowView.textInset
        ) { row in
            TransactionRowView(row: row)
        }
    }
}
