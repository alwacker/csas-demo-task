import SwiftUI

struct TransactionRowView: View {
    static let textInset = Layout.horizontalPadding + Layout.iconSize + Layout.spacing

    let row: TransactionRow

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        layout {
            icon
            info
            amount
        }
        .padding(.vertical, Layout.verticalPadding)
        .padding(.horizontal, Layout.horizontalPadding)
        .accessibilityElement(children: .combine)
    }

    private var layout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: Layout.spacing))
            : AnyLayout(HStackLayout(alignment: .top, spacing: Layout.spacing))
    }

    private var icon: some View {
        Image(systemName: row.direction.iconName)
            .font(.system(size: Layout.glyph, weight: .semibold))
            .foregroundStyle(row.direction.iconForeground)
            .frame(width: Layout.iconSize, height: Layout.iconSize)
            .background(row.direction.iconBackground, in: .circle)
            .accessibilityHidden(true)
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: Layout.lineGap) {
            Text(row.title)
                .font(.headline)
                .foregroundStyle(Color.Palette.textPrimary)
                .lineLimit(1)

            if let message = row.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Color.Palette.textSecondary)
                    .lineLimit(2)
            }

            Text(row.date)
                .font(.footnote)
                .foregroundStyle(Color.Palette.textSecondary)

            if let category = row.category {
                CategoryChipView(title: category)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var amount: some View {
        Text(row.amount)
            .font(.headline.monospacedDigit())
            .foregroundStyle(row.direction.amountColor)
    }
}

private enum Layout {
    static let verticalPadding: CGFloat = 13
    static let horizontalPadding: CGFloat = 14
    static let iconSize: CGFloat = 38
    static let glyph: CGFloat = 17
    static let spacing: CGFloat = 12
    static let lineGap: CGFloat = 3
}
