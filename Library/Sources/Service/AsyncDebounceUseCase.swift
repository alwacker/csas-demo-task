@MainActor
public protocol AsyncDebounceUseCase: AnyObject {
    func callAsFunction(interval: Duration, _ action: @escaping @Sendable () async -> Void)
}

@MainActor
final class AsyncDebounceUseCaseImp: AsyncDebounceUseCase {
    private var task: Task<Void, Never>?

    func callAsFunction(interval: Duration, _ action: @escaping @Sendable () async -> Void) {
        task?.cancel()
        task = Task {
            try? await Task.sleep(for: interval)
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
