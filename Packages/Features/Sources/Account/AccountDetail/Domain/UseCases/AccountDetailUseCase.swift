protocol AccountDetailUseCase: Sendable {
    func callAsFunction(id: String) async throws -> AccountDetailEntity
}

struct AccountDetailUseCaseImp: AccountDetailUseCase {
    private let repository: any AccountDetailRepository

    init(repository: any AccountDetailRepository) {
        self.repository = repository
    }

    func callAsFunction(id: String) async throws -> AccountDetailEntity {
        await repository.download(id: id)
        return try await repository.observe().getValue().getData()
    }
}
