import Localization
import Models
import SwiftUI

public struct ErrorStateView: View {
    private let model: ErrorViewModel
    private let onRetry: @MainActor @Sendable () async -> Void

    public init(model: ErrorViewModel, onRetry: @escaping @MainActor @Sendable () async -> Void) {
        self.model = model
        self.onRetry = onRetry
    }

    public var body: some View {
        ContentUnavailableView {
            Label {
                Text(model.title)
            } icon: {
                Image.Icon.errorCircle
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.amountNegative)
            }
        } description: {
            VStack(spacing: Layout.descriptionSpacing) {
                Text(model.message)
                if let code = model.code {
                    Text(code)
                        .font(.caption.monospaced())
                }
            }
        } actions: {
            Button(Localization.Common.tryAgain) {
                Task { await onRetry() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.Palette.accent)
        }
    }
}

private enum Layout {
    static let descriptionSpacing: CGFloat = 8
}
