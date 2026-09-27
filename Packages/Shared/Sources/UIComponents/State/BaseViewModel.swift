import Combine

@MainActor
open class BaseViewModel<State: Sendable>: ObservableObject {
    @Published public private(set) var state: State

    public init(state: State) {
        self.state = state
    }

    public func setState(_ state: State) {
        self.state = state
    }
}
