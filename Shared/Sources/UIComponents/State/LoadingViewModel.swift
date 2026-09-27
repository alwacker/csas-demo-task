import Models

@MainActor
open class LoadingViewModel<Content: Sendable>: BaseViewModel<ViewModelState<Content>> {
    public override init(state: ViewModelState<Content> = .loading) {
        super.init(state: state)
    }

    public func setContent(_ content: Content) {
        setState(.content(content))
    }

    public func setLoading() {
        setState(.loading)
    }

    public func setError(_ model: ErrorViewModel) {
        setState(.error(model))
    }
}
