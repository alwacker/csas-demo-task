extension AccountContainer {
    func makeAccountListRepository() -> AccountListRepository {
        makeShared {
            AccountListRepositoryImp(
                apiProvider: self.networkingContainer.makeAPIProvider(),
                converter: self.makeAccountListConverter(),
                errorConverter: self.appErrorContainer.makeDomainErrorConverter()
            )
        }
    }
    
    private func makeAccountListConverter() -> AccountListConverter {
        AccountListConverterImp(accountConverter: makeAccountConverter())
    }
    
    private func makeAccountConverter() -> AccountConverter {
        AccountConverterImp(amountConverter: self.modelsContainer.makeAmountConverter())
    }
}
