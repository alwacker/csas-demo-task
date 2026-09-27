@MainActor
open class BaseContainer {
    private struct WeakBox {
        weak var entity: AnyObject?
    }

    private var singletons = [DependencyInjectionKey: AnyObject]()
    private var shared = [DependencyInjectionKey: WeakBox]()

    public init() {}

    public func makeSingleton<T: AnyObject>(
        function: String = #function,
        file: String = #file,
        line: UInt = #line,
        onBuild: @MainActor @escaping () -> T
    ) -> T {
        let key = DependencyInjectionKey(type: T.self, function: function, file: file, line: line)

        if let instance = singletons[key] as? T {
            return instance
        } else {
            let instance = onBuild()
            singletons[key] = instance
            return instance
        }
    }

    public func makeShared<T: AnyObject>(
        function: String = #function,
        file: String = #file,
        line: UInt = #line,
        onBuild: @MainActor @escaping () -> T
    ) -> T {
        let key = DependencyInjectionKey(type: T.self, function: function, file: file, line: line)

        if let instance = shared[key]?.entity as? T {
            return instance
        } else {
            let instance = onBuild()
            shared[key] = WeakBox(entity: instance as AnyObject)
            return instance
        }
    }
}
