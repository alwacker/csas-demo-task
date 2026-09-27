import Models
import Testing
@testable import Account

@Suite("TransactionListUseCase")
struct TransactionListUseCaseTests {
    @Test("downloads the requested page and returns the repository data")
    func test_givenData_whenCall_thenReturnsEntity() async throws {
        // arrange
        let entity = TransactionListEntity.stub(pageNumber: 1, transactions: [.stub()], nextPage: 2)
        let repository = TransactionListRepositoryFake(result: .data(entity))
        let sut = TransactionListUseCaseImp(repository: repository)

        // act
        let result = try await sut(id: "000000-2906478309", page: 1)

        // assert
        #expect(result == entity)
        #expect(await repository.downloads == [.init(id: "000000-2906478309", page: 1)])
    }

    @Test("a page that did not move forward ends the list")
    func test_givenRepeatedPage_whenCall_thenLastEmptyPage() async throws {
        // arrange
        let repeated = TransactionListEntity.stub(pageNumber: 0, transactions: [.stub()], nextPage: 1)
        let sut = TransactionListUseCaseImp(repository: TransactionListRepositoryFake(result: .data(repeated)))

        // act
        let result = try await sut(id: "000000-2906478309", page: 1)

        // assert
        #expect(result == .stub(pageNumber: 1, transactions: [], nextPage: nil))
    }

    @Test("rethrows the repository error")
    func test_givenError_whenCall_thenThrows() async {
        // arrange
        let sut = TransactionListUseCaseImp(repository: TransactionListRepositoryFake(result: .error(.offline)))

        // act & assert
        await #expect(throws: DomainError.offline) {
            try await sut(id: "000000-2906478309", page: 0)
        }
    }
}
