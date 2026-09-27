import SwiftUI

public extension View {
    func onLoadAsync(perform action: @escaping @MainActor @Sendable () async -> Void) -> some View {
        modifier(OnLoadAsyncModifier(action: action))
    }
}

private struct OnLoadAsyncModifier: ViewModifier {
    @State private var didLoad = false
    let action: @MainActor @Sendable () async -> Void

    func body(content: Content) -> some View {
        content.task {
            guard !didLoad else { return }
            didLoad = true
            await action()
        }
    }
}
