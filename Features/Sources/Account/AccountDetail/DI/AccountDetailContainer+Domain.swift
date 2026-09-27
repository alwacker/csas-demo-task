extension AccountContainer {
    func makeAccountDetailUseCase() -> AccountDetailUseCase {
        AccountDetailUseCaseImp(repository: makeAccountDetailRepository())
    }

    func makeTransactionListUseCase() -> TransactionListUseCase {
        TransactionListUseCaseImp(repository: makeTransactionListRepository())
    }
}
