import Models

protocol AccountListConverter: Sendable {
    func convert(_ model: AccountListModel) -> AccountListEntity
}

struct AccountListConverterImp: AccountListConverter {
    private let accountConverter: AccountConverter

    init(accountConverter: AccountConverter) {
        self.accountConverter = accountConverter
    }

    func convert(_ model: AccountListModel) -> AccountListEntity {
        AccountListEntity(
            pageNumber: model.pageNumber,
            recordCount: model.recordCount,
            nextPage: model.nextPage,
            accounts: model.accounts.map(accountConverter.convert)
        )
    }
}
