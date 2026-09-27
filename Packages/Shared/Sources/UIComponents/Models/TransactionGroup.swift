public struct TransactionGroup: Identifiable, Equatable, Sendable {
    public let title: String
    public let rows: [TransactionRow]

    public var id: String { title }

    public init(title: String, rows: [TransactionRow]) {
        self.title = title
        self.rows = rows
    }
}
