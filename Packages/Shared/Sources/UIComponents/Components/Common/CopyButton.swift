import Localization
import SwiftUI
import UIKit

struct CopyButton: View {
    enum Size {
        case regular
        case large

        var box: CGFloat {
            switch self {
            case .regular: 28
            case .large: 32
            }
        }

        var glyph: CGFloat {
            switch self {
            case .regular: 16
            case .large: 18
            }
        }
    }

    private let value: String
    private let size: Size
    private let accessibilityLabel: String

    @State private var isCopied = false

    init(value: String, size: Size, accessibilityLabel: String) {
        self.value = value
        self.size = size
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        Button {
            UIPasteboard.general.string = value
            isCopied = true
            Task {
                try? await Task.sleep(for: .seconds(1.5))
                isCopied = false
            }
        } label: {
            (isCopied ? Image.Icon.checkmark : Image.Icon.copy)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size.glyph, height: size.glyph)
                .foregroundStyle(Color.Palette.accent)
                .frame(width: size.box, height: size.box)
                .background(Color.Palette.accentSubtle, in: .rect(cornerRadius: .buttonRadius))
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle().inset(by: (size.box - Layout.minHitArea) / 2))
        .accessibilityLabel(isCopied ? Localization.Common.copied : accessibilityLabel)
    }
}

private enum Layout {
    static let minHitArea: CGFloat = 44
}
