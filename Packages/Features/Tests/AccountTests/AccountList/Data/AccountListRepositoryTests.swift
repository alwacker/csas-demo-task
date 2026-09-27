import Models
import Networking
import Pipeline
import Testing
@testable import Account

@Suite("AccountListRepository")
struct AccountListRepositoryTests {
    private static let model = AccountListModel(pageNumber: 1, nextPage: 2, recordCount: 120, accounts: [.stub()])

    private let converter = AccountListConverterImp(
        accountConverter: AccountConverterImp(amountConverter: AmountConverterStub())
    )

    @Test("requests the page with the filter and publishes the converted data")
    func test_givenResponse_whenDownload_thenData() async {
        // arrange
        let apiProvider = APIProviderFake(response: Self.model)
        let sut = makeSUT(apiProvider: apiProvider)

        // act
        await sut.download(page: 1, filter: "fond")

        // assert
        #expect(await apiProvider.requests == [
            .init(endpoint: .accountList, method: .get, parameters: ["page": "1", "size": "50", "filter": "fond"])
        ])
        #expect(await sut.observe().getValue() == .data(converter.convert(Self.model)))
    }

    @Test("an empty filter is not sent")
    func test_givenEmptyFilter_whenDownload_thenNoFilterParameter() async {
        // arrange
        let apiProvider = APIProviderFake(response: Self.model)
        let sut = makeSUT(apiProvider: apiProvider)

        // act
        await sut.download(page: 0, filter: "")

        // assert
        #expect(await apiProvider.requests.first?.parameters == ["page": "0", "size": "50"])
    }

    @Test("a failed request publishes the converted error")
    func test_givenError_whenDownload_thenError() async {
        // arrange
        let sut = makeSUT(apiProvider: APIProviderFake(error: APIError.unexpectedResponse))

        // act
        await sut.download(page: 0, filter: nil)

        // assert
        #expect(await sut.observe().getValue() == .error(.offline))
    }

    @Test("a cancelled download publishes nothing but loading")
    func test_givenCancelledTask_whenDownload_thenStaysLoading() async {
        // arrange
        let sut = makeSUT(apiProvider: APIProviderFake(response: Self.model))

        // act
        let task = Task { await sut.download(page: 0, filter: nil) }
        task.cancel()
        await task.value

        // assert
        #expect(await sut.observe().getValue() == .loading)
    }

    private func makeSUT(apiProvider: APIProviderFake) -> AccountListRepositoryImp {
        AccountListRepositoryImp(
            apiProvider: apiProvider,
            converter: converter,
            errorConverter: DomainErrorConverterStub()
        )
    }
}
