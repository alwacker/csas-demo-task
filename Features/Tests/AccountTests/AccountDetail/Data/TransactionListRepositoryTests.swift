import Models
import Networking
import Pipeline
import Testing
@testable import Account

@Suite("TransactionListRepository")
struct TransactionListRepositoryTests {
    private static let id = "000000-2906478309"
    private static let model = TransactionListModel(pageNumber: 1, nextPage: nil, transactions: [.stub()])

    private let converter = TransactionListConverterImp(
        transactionConverter: TransactionConverterImp(amountConverter: AmountConverterStub())
    )

    @Test("requests the page and publishes the converted data")
    func test_givenResponse_whenDownload_thenData() async {
        // arrange
        let apiProvider = APIProviderFake(response: Self.model)
        let sut = makeSUT(apiProvider: apiProvider)

        // act
        await sut.download(id: Self.id, page: 1)

        // assert
        #expect(await apiProvider.requests == [
            .init(
                endpoint: .accountTransactions(id: Self.id),
                method: .get,
                parameters: ["page": "1", "size": "50"]
            )
        ])
        #expect(await sut.observe().getValue() == .data(converter.convert(Self.model)))
    }

    @Test("a failed request publishes the converted error")
    func test_givenError_whenDownload_thenError() async {
        // arrange
        let sut = makeSUT(apiProvider: APIProviderFake(error: APIError.unexpectedResponse))

        // act
        await sut.download(id: Self.id, page: 0)

        // assert
        #expect(await sut.observe().getValue() == .error(.offline))
    }

    private func makeSUT(apiProvider: APIProviderFake) -> TransactionListRepositoryImp {
        TransactionListRepositoryImp(
            apiProvider: apiProvider,
            converter: converter,
            errorConverter: DomainErrorConverterStub()
        )
    }
}
