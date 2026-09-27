import Models
import SwiftUI

public struct ViewModelStateView<Content: Sendable, LoadingView: View, ContentView: View>: View {
    private let state: ViewModelState<Content>
    private let onRetry: @MainActor @Sendable () async -> Void
    private let loadingView: () -> LoadingView
    private let contentView: (Content) -> ContentView

    public init(
        state: ViewModelState<Content>,
        onRetry: @MainActor @Sendable @escaping () async -> Void,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder contentView: @escaping (Content) -> ContentView
    ) {
        self.state = state
        self.onRetry = onRetry
        self.loadingView = loadingView
        self.contentView = contentView
    }

    public var body: some View {
        switch state {
        case .loading:
            loadingView()
        case let .content(content):
            contentView(content)
        case let .error(model):
            ErrorStateView(model: model, onRetry: onRetry)
        }
    }
}
