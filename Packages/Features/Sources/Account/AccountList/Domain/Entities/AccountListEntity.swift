struct AccountListEntity: Sendable, Equatable {
    let pageNumber: Int
    let recordCount: Int
    let nextPage: Int?
    let accounts: [AccountEntity]
}
