import SwiftUI

public struct StatusChipView: View {
    private let status: AccountStatus

    public init(status: AccountStatus) {
        self.status = status
    }

    public var body: some View {
        Text(status.title)
            .font(.caption2.weight(.semibold))
            .tracking(Layout.tracking)
            .foregroundStyle(status.chipForeground)
            .padding(.vertical, Layout.verticalPadding)
            .padding(.horizontal, Layout.horizontalPadding)
            .background(status.chipBackground, in: .rect(cornerRadius: .chipRadius))
    }
}

private enum Layout {
    static let verticalPadding: CGFloat = 3
    static let horizontalPadding: CGFloat = 8
    static let tracking: CGFloat = 0.2
}
