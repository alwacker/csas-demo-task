import Service

@MainActor
final class AsyncDebounceUseCaseSpy: AsyncDebounceUseCase {
    private(set) var intervals: [Duration] = []
    private(set) var actions: [@Sendable () async -> Void] = []

    func callAsFunction(interval: Duration, _ action: @escaping @Sendable () async -> Void) {
        intervals.append(interval)
        actions.append(action)
    }
}
