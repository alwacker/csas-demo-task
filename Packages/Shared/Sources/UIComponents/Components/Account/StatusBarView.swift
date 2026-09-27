import SwiftUI

struct StatusBarView: View {
    let status: AccountStatus

    var body: some View {
        Rectangle()
            .fill(status.barColor)
            .frame(height: Layout.height)
            .accessibilityHidden(true)
    }
}

private enum Layout {
    static let height: CGFloat = 3
}
