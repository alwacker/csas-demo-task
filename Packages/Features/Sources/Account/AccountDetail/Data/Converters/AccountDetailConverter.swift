import Models

protocol AccountDetailConverter: Sendable {
    func convert(_ model: AccountDetailModel) -> AccountDetailEntity
}

struct AccountDetailConverterImp: AccountDetailConverter {
    private let amountConverter: AmountConverter

    init(amountConverter: AmountConverter) {
        self.amountConverter = amountConverter
    }

    func convert(_ model: AccountDetailModel) -> AccountDetailEntity {
        AccountDetailEntity(
            accountNumber: model.accountNumber,
            bankCode: model.bankCode,
            transparencyFrom: model.transparencyFrom,
            transparencyTo: model.transparencyTo,
            publicationTo: model.publicationTo,
            actualizationDate: model.actualizationDate,
            amount: amountConverter.convert(value: model.balance, currency: model.currency),
            name: model.name,
            description: model.description,
            note: model.note,
            iban: model.iban
        )
    }
}
