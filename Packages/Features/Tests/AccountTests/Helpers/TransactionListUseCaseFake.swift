import Models
@testable import Account

actor TransactionListUseCaseFake: TransactionListUseCase {
    private(set) var requestedPages: [Int] = []
    private var results: [Result<TransactionListEntity, DomainError>]

    init(results: [Result<TransactionListEntity, DomainError>]) {
        self.results = results
    }

    func callAsFunction(id: String, page: Int) async throws -> TransactionListEntity {
        requestedPages.append(page)
        guard !results.isEmpty else { throw DomainError.unknown }
        return try results.removeFirst().get()
    }
}
