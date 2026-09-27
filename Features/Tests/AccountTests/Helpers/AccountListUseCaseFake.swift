import Models
@testable import Account

actor AccountListUseCaseFake: AccountListUseCase {
    struct Call: Equatable {
        let page: Int
        let query: String?
    }

    private(set) var calls: [Call] = []
    private var results: [Result<AccountListEntity, DomainError>]

    init(results: [Result<AccountListEntity, DomainError>]) {
        self.results = results
    }

    func callAsFunction(page: Int, query: String?) async throws -> AccountListEntity {
        calls.append(Call(page: page, query: query))
        guard !results.isEmpty else { throw DomainError.unknown }
        return try results.removeFirst().get()
    }
}
