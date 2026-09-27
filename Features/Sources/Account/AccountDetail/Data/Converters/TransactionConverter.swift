import Models

protocol TransactionConverter: Sendable {
    func convert(_ model: TransactionModel) -> TransactionEntity
}

struct TransactionConverterImp: TransactionConverter {
    private let amountConverter: AmountConverter

    init(amountConverter: AmountConverter) {
        self.amountConverter = amountConverter
    }

    func convert(_ model: TransactionModel) -> TransactionEntity {
        TransactionEntity(
            amount: amountConverter.convert(value: model.amount.value, currency: model.amount.currency),
            processingDate: model.processingDate,
            typeDescription: model.typeDescription,
            counterpartyName: model.sender?.name,
            message: model.sender?.description
        )
    }
}
