import Models
import Testing
@testable import Account

@Suite("AccountDetailUseCase")
struct AccountDetailUseCaseTests {
    @Test("downloads the account and returns the repository data")
    func test_givenData_whenCall_thenReturnsEntity() async throws {
        // arrange
        let entity = AccountDetailEntity.stub()
        let repository = AccountDetailRepositoryFake(result: .data(entity))
        let sut = AccountDetailUseCaseImp(repository: repository)

        // act
        let result = try await sut(id: "000000-2906478309")

        // assert
        #expect(result == entity)
        #expect(await repository.downloadedIDs == ["000000-2906478309"])
    }

    @Test("rethrows the repository error")
    func test_givenError_whenCall_thenThrows() async {
        // arrange
        let sut = AccountDetailUseCaseImp(repository: AccountDetailRepositoryFake(result: .error(.notFound)))

        // act & assert
        await #expect(throws: DomainError.notFound) {
            try await sut(id: "000000-2906478309")
        }
    }
}
