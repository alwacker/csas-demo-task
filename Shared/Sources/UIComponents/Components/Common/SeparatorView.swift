import SwiftUI

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .fill(Color.Palette.separator)
            .frame(height: Layout.height)
            .accessibilityHidden(true)
    }
}

private enum Layout {
    static let height: CGFloat = 1
}
