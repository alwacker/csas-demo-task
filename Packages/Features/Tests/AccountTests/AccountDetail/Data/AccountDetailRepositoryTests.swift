import Models
import Networking
import Pipeline
import Testing
@testable import Account

@Suite("AccountDetailRepository")
struct AccountDetailRepositoryTests {
    private static let id = "000000-2906478309"

    private let converter = AccountDetailConverterImp(amountConverter: AmountConverterStub())

    @Test("requests the account by id and publishes the converted data")
    func test_givenResponse_whenDownload_thenData() async {
        // arrange
        let model = AccountDetailModel.stub()
        let apiProvider = APIProviderFake(response: model)
        let sut = makeSUT(apiProvider: apiProvider)

        // act
        await sut.download(id: Self.id)

        // assert
        #expect(await apiProvider.requests == [.init(endpoint: .accountDetail(id: Self.id), method: .get, parameters: [:])])
        #expect(await sut.observe().getValue() == .data(converter.convert(model)))
    }

    @Test("a failed request publishes the converted error")
    func test_givenError_whenDownload_thenError() async {
        // arrange
        let sut = makeSUT(apiProvider: APIProviderFake(error: APIError.unexpectedResponse))

        // act
        await sut.download(id: Self.id)

        // assert
        #expect(await sut.observe().getValue() == .error(.offline))
    }

    private func makeSUT(apiProvider: APIProviderFake) -> AccountDetailRepositoryImp {
        AccountDetailRepositoryImp(
            apiProvider: apiProvider,
            converter: converter,
            errorConverter: DomainErrorConverterStub()
        )
    }
}
