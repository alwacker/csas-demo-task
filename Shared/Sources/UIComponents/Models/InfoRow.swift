public struct InfoRow: Identifiable, Equatable, Sendable {
    public let label: String
    public let value: String
    public let isCopyable: Bool

    public var id: String { label }

    public init(label: String, value: String, isCopyable: Bool = false) {
        self.label = label
        self.value = value
        self.isCopyable = isCopyable
    }
}
