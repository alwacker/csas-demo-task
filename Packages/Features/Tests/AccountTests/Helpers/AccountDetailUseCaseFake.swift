import Models
@testable import Account

actor AccountDetailUseCaseFake: AccountDetailUseCase {
    private(set) var requestedIDs: [String] = []
    private var results: [Result<AccountDetailEntity, DomainError>]

    init(results: [Result<AccountDetailEntity, DomainError>]) {
        self.results = results
    }

    func callAsFunction(id: String) async throws -> AccountDetailEntity {
        requestedIDs.append(id)
        guard !results.isEmpty else { throw DomainError.unknown }
        return try results.removeFirst().get()
    }
}
