import SwiftUI

struct CategoryChipView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption2)
            .foregroundStyle(Color.Palette.textSecondary)
            .padding(.vertical, Layout.verticalPadding)
            .padding(.horizontal, Layout.horizontalPadding)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.radius)
                    .stroke(Color.Palette.separator, lineWidth: Layout.borderWidth)
            )
    }
}

private enum Layout {
    static let verticalPadding: CGFloat = 2
    static let horizontalPadding: CGFloat = 8
    static let radius: CGFloat = 9
    static let borderWidth: CGFloat = 1
}
