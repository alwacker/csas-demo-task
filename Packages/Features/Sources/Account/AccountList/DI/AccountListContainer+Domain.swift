extension AccountContainer {
    func makeAccountListUseCase() -> AccountListUseCase {
        AccountListUseCaseImp(repository: self.makeAccountListRepository())
    }
}
