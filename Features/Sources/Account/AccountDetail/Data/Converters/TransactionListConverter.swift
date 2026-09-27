protocol TransactionListConverter: Sendable {
    func convert(_ model: TransactionListModel) -> TransactionListEntity
}

struct TransactionListConverterImp: TransactionListConverter {
    private let transactionConverter: any TransactionConverter

    init(transactionConverter: any TransactionConverter) {
        self.transactionConverter = transactionConverter
    }

    func convert(_ model: TransactionListModel) -> TransactionListEntity {
        TransactionListEntity(
            pageNumber: model.pageNumber,
            nextPage: model.nextPage,
            transactions: model.transactions.map(transactionConverter.convert)
        )
    }
}
