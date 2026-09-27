import Models
import Testing
@testable import Account

@Suite("AccountListUseCase")
struct AccountListUseCaseTests {
    @Test("downloads the requested page and returns the repository data")
    func test_givenData_whenCall_thenReturnsEntity() async throws {
        // arrange
        let entity = AccountListEntity.stub(pageNumber: 2, accounts: [.stub()], nextPage: 3)
        let repository = AccountListRepositoryFake(result: .data(entity))
        let sut = AccountListUseCaseImp(repository: repository)

        // act
        let result = try await sut(page: 2, query: "fond")

        // assert
        #expect(result == entity)
        #expect(await repository.downloads == [.init(page: 2, filter: "fond")])
    }

    @Test("a page that did not move forward ends the list")
    func test_givenRepeatedPage_whenCall_thenLastEmptyPage() async throws {
        // arrange
        let repeated = AccountListEntity.stub(pageNumber: 0, accounts: [.stub()], nextPage: 1)
        let sut = AccountListUseCaseImp(repository: AccountListRepositoryFake(result: .data(repeated)))

        // act
        let result = try await sut(page: 1, query: nil)

        // assert
        #expect(result == AccountListEntity(pageNumber: 1, recordCount: 1, nextPage: nil, accounts: []))
    }

    @Test("rethrows the repository error")
    func test_givenError_whenCall_thenThrows() async {
        // arrange
        let sut = AccountListUseCaseImp(repository: AccountListRepositoryFake(result: .error(.notFound)))

        // act & assert
        await #expect(throws: DomainError.notFound) {
            try await sut(page: 0, query: nil)
        }
    }
}
