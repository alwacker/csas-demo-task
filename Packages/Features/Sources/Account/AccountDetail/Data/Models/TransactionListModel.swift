struct TransactionListModel: Decodable, Sendable, Equatable {
    let pageNumber: Int
    let nextPage: Int?
    let transactions: [TransactionModel]
}
