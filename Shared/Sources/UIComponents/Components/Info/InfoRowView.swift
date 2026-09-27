import Localization
import SwiftUI

struct InfoRowView: View {
    let row: InfoRow

    var body: some View {
        HStack(spacing: Layout.textToCopy) {
            VStack(alignment: .leading, spacing: Layout.labelToValue) {
                Text(row.label)
                    .font(.footnote)
                    .foregroundStyle(Color.Palette.textSecondary)

                Text(row.value)
                    .font(row.isCopyable ? .body.monospaced() : .body)
                    .foregroundStyle(Color.Palette.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)

            if row.isCopyable {
                CopyButton(value: row.value, size: .large, accessibilityLabel: Localization.Common.copy(row.label))
            }
        }
        .padding(.vertical, Layout.verticalPadding)
        .padding(.horizontal, .screenMargin)
    }
}

private enum Layout {
    static let labelToValue: CGFloat = 3
    static let textToCopy: CGFloat = 12
    static let verticalPadding: CGFloat = 12
}
