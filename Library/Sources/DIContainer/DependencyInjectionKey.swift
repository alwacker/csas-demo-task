struct DependencyInjectionKey: Hashable {
    let type: ObjectIdentifier
    let function: String
    let file: String
    let line: UInt

    init(type: Any.Type, function: String, file: String, line: UInt) {
        self.type = ObjectIdentifier(type)
        self.function = function
        self.file = file
        self.line = line
    }
}
