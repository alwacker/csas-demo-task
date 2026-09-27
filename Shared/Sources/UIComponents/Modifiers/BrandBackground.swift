import SwiftUI

public extension View {
    func brandBackground() -> some View {
        modifier(BrandBackground())
    }
}

private struct BrandBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(alignment: .top) { gradient }
            .background(Color.Palette.backgroundPrimary)
    }

    private var gradient: some View {
        LinearGradient(
            colors: [
                Color.Palette.brandFill.opacity(Layout.topOpacity),
                Color.Palette.brandFill.opacity(0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: Layout.height)
        .ignoresSafeArea(edges: .all)
        .accessibilityHidden(true)
    }
}

private enum Layout {
    static let height: CGFloat = 320
    static let topOpacity: Double = 0.35
}
