protocol TransactionListUseCase: Sendable {
    func callAsFunction(id: String, page: Int) async throws -> TransactionListEntity
}

struct TransactionListUseCaseImp: TransactionListUseCase {
    private let repository: any TransactionListRepository

    init(repository: any TransactionListRepository) {
        self.repository = repository
    }

    func callAsFunction(id: String, page: Int) async throws -> TransactionListEntity {
        await repository.download(id: id, page: page)
        let entity = try await repository.observe().getValue().getData()
        guard entity.pageNumber == page else {
            return TransactionListEntity(pageNumber: page, nextPage: nil, transactions: [])
        }
        return entity
    }
}
