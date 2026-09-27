public struct TransactionRow: Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let message: String?
    public let date: String
    public let category: String?
    public let amount: String
    public let direction: TransactionDirection

    public init(
        id: Int,
        title: String,
        message: String?,
        date: String,
        category: String?,
        amount: String,
        direction: TransactionDirection
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.category = category
        self.amount = amount
        self.direction = direction
    }
}
