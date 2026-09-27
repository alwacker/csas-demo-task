@MainActor
public final class ServiceContainer {
    public init() {}

    public func makeAsyncDebounceUseCase() -> AsyncDebounceUseCase {
        AsyncDebounceUseCaseImp()
    }
}
