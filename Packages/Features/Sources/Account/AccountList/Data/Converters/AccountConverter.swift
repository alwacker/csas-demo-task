import Models

protocol AccountConverter: Sendable {
    func convert(_ model: AccountModel) -> AccountEntity
}

struct AccountConverterImp: AccountConverter {
    private let amountConverter: AmountConverter

    init(amountConverter: AmountConverter) {
        self.amountConverter = amountConverter
    }

    func convert(_ model: AccountModel) -> AccountEntity {
        AccountEntity(
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
