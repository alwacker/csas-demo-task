import SwiftUI

public enum TransactionDirection: Equatable, Sendable {
    case incoming
    case outgoing

    var iconName: String {
        switch self {
        case .incoming: "arrow.down.left"
        case .outgoing: "arrow.up.right"
        }
    }

    var iconForeground: Color {
        switch self {
        case .incoming: Color.Palette.iconIncomingFg
        case .outgoing: Color.Palette.iconOutgoingFg
        }
    }

    var iconBackground: Color {
        switch self {
        case .incoming: Color.Palette.iconIncomingBg
        case .outgoing: Color.Palette.iconOutgoingBg
        }
    }

    var amountColor: Color {
        switch self {
        case .incoming: Color.Palette.amountPositive
        case .outgoing: Color.Palette.textPrimary
        }
    }
}
