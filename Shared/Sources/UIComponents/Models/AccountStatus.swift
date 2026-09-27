import Localization
import SwiftUI

public enum AccountStatus: Equatable, Sendable {
    case active
    case closed

    var title: String {
        switch self {
        case .active: Localization.Common.active
        case .closed: Localization.Common.closed
        }
    }

    var barColor: Color {
        switch self {
        case .active: Color.Palette.stateOpenBar
        case .closed: Color.Palette.stateClosedBar
        }
    }

    var chipBackground: Color {
        switch self {
        case .active: Color.Palette.accentSubtle
        case .closed: Color.Palette.stateClosedSubtle
        }
    }

    var chipForeground: Color {
        switch self {
        case .active: Color.Palette.accent
        case .closed: Color.Palette.stateClosedText
        }
    }
}
