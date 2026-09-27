import Foundation

public protocol Pipeline<Value>: Actor {
    associatedtype Value: Sendable

    func getValue() -> Value
    func values() -> AsyncStream<Value>
}

public actor StatePipeline<Value: Sendable>: Pipeline {
    private var value: Value
    private var continuations: [UUID: AsyncStream<Value>.Continuation] = [:]

    public init(value: Value) {
        self.value = value
    }

    public func send(value newValue: Value) {
        value = newValue
        continuations.values.forEach { $0.yield(newValue) }
    }

    public func getValue() -> Value {
        value
    }

    public func values() -> AsyncStream<Value> {
        let (stream, continuation) = AsyncStream.makeStream(of: Value.self, bufferingPolicy: .unbounded)
        let id = UUID()
        continuations[id] = continuation
        continuation.yield(value)
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeSubscriber(id) }
        }
        return stream
    }

    private func removeSubscriber(_ id: UUID) {
        continuations[id] = nil
    }
}
