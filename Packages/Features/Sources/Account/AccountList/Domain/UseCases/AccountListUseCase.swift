protocol AccountListUseCase: Sendable {
    func callAsFunction(page: Int, query: String?) async throws -> AccountListEntity
}

struct AccountListUseCaseImp: AccountListUseCase {
    private let repository: any AccountListRepository

    init(repository: any AccountListRepository) {
        self.repository = repository
    }

    func callAsFunction(page: Int, query: String?) async throws -> AccountListEntity {
        await repository.download(page: page, filter: query)
        let entity = try await repository.observe().getValue().getData()
        guard entity.pageNumber == page else {
            return AccountListEntity(pageNumber: page, recordCount: entity.recordCount, nextPage: nil, accounts: [])
        }
        return entity
    }
}
