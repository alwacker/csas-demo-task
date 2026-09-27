struct TransactionListEntity: Sendable, Equatable {
    let pageNumber: Int
    let nextPage: Int?
    let transactions: [TransactionEntity]
}
