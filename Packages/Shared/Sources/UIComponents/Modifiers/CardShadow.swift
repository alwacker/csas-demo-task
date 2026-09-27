import SwiftUI

extension View {
    func cardShadow() -> some View {
        modifier(CardShadow())
    }
}

private struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(Layout.contactOpacity), radius: Layout.contactRadius, y: Layout.contactY)
            .shadow(color: .black.opacity(Layout.ambientOpacity), radius: Layout.ambientRadius, y: Layout.ambientY)
    }
}

private enum Layout {
    static let contactOpacity: Double = 0.06
    static let contactRadius: CGFloat = 2
    static let contactY: CGFloat = 1
    static let ambientOpacity: Double = 0.10
    static let ambientRadius: CGFloat = 12
    static let ambientY: CGFloat = 4
}
