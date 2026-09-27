struct AccountListModel: Decodable, Sendable, Equatable {
    let pageNumber: Int
    let nextPage: Int?
    let recordCount: Int
    let accounts: [AccountModel]
}
