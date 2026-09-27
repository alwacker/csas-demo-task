public struct InfoSection: Identifiable, Equatable, Sendable {
    public let title: String
    public let rows: [InfoRow]

    public var id: String { title }

    public init(title: String, rows: [InfoRow]) {
        self.title = title
        self.rows = rows
    }
}
