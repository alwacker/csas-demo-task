extension AccountContainer {
    func makeAccountDetailRepository() -> AccountDetailRepository {
        makeShared {
            AccountDetailRepositoryImp(
                apiProvider: self.networkingContainer.makeAPIProvider(),
                converter: self.makeAccountDetailConverter(),
                errorConverter: self.appErrorContainer.makeDomainErrorConverter()
            )
        }
    }

    func makeTransactionListRepository() -> TransactionListRepository {
        makeShared {
            TransactionListRepositoryImp(
                apiProvider: self.networkingContainer.makeAPIProvider(),
                converter: self.makeTransactionListConverter(),
                errorConverter: self.appErrorContainer.makeDomainErrorConverter()
            )
        }
    }

    private func makeAccountDetailConverter() -> AccountDetailConverter {
        AccountDetailConverterImp(amountConverter: modelsContainer.makeAmountConverter())
    }

    private func makeTransactionListConverter() -> TransactionListConverter {
        TransactionListConverterImp(transactionConverter: makeTransactionConverter())
    }

    private func makeTransactionConverter() -> TransactionConverter {
        TransactionConverterImp(amountConverter: modelsContainer.makeAmountConverter())
    }
}
