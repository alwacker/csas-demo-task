import Models

public enum ViewModelState<Content: Sendable>: Sendable {
    case loading
    case content(Content)
    case error(ErrorViewModel)
}

extension ViewModelState: Equatable where Content: Equatable {}

public extension ViewModelState {
    var contentModel: Content? {
        guard case let .content(content) = self else { return nil }
        return content
    }
}
