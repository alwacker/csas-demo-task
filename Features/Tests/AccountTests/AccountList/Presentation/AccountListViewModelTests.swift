import Foundation
import Models
import SharedExtensions
import Testing
import UIComponents
@testable import Account

@MainActor
@Suite("AccountListViewModel")
struct AccountListViewModelTests {
    private let router = AccountListRouterSpy()
    private let debounce = AsyncDebounceUseCaseSpy()
    private let contentConverter = AccountListContentConverterImp(
        amountFormatter: AmountFormatterStub(),
        accountNumberFormatter: AccountNumberFormatterStub()
    )

    @Test("load shows the first page")
    func test_givenData_whenLoad_thenContent() async {
        // arrange
        let entity = AccountListEntity.stub(accounts: [.stub()])
        let useCase = AccountListUseCaseFake(results: [.success(entity)])
        let sut = makeSUT(useCase: useCase)

        // act
        await sut.onLoad()

        // assert
        #expect(sut.state == .content(contentConverter.convert(entity, previous: nil, query: "")))
        #expect(await useCase.calls == [.init(page: 0, query: "")])
    }

    @Test("a failed load shows the error")
    func test_givenError_whenLoad_thenError() async {
        // arrange
        let sut = makeSUT(useCase: AccountListUseCaseFake(results: [.failure(.offline)]))

        // act
        await sut.onLoad()

        // assert
        #expect(sut.state == .error(ErrorViewModelConverterStub.model))
    }

    @Test("reaching the end loads the next page and appends it")
    func test_givenNextPage_whenReachedEnd_thenAppended() async {
        // arrange
        let useCase = AccountListUseCaseFake(results: [
            .success(.stub(accounts: [.stub(accountNumber: "1")], nextPage: 1)),
            .success(.stub(accounts: [.stub(accountNumber: "2")]))
        ])
        let sut = makeSUT(useCase: useCase)
        await sut.onLoad()

        // act
        await sut.onReachedEnd()

        // assert
        guard case let .accounts(rows, hasMore) = sut.state.contentModel?.body else {
            Issue.record("expected accounts, got \(sut.state)")
            return
        }
        #expect(rows.map(\.id) == ["1", "2"])
        #expect(hasMore == false)
        #expect(await useCase.calls.map(\.page) == [0, 1])
    }

    @Test("reaching the end of the last page loads nothing")
    func test_givenNoNextPage_whenReachedEnd_thenNoRequest() async {
        // arrange
        let useCase = AccountListUseCaseFake(results: [.success(.stub(accounts: [.stub()]))])
        let sut = makeSUT(useCase: useCase)
        await sut.onLoad()

        // act
        await sut.onReachedEnd()

        // assert
        #expect(await useCase.calls.count == 1)
    }

    @Test("every keystroke goes through the debounce with the configured interval")
    func test_givenTyping_whenSearch_thenDebounced() {
        // arrange
        let sut = makeSUT(useCase: AccountListUseCaseFake(results: []))

        // act
        sut.onSearch("f")
        sut.onSearch("fo")

        // assert
        #expect(debounce.intervals == [.milliseconds(300), .milliseconds(300)])
    }

    @Test("the same text does not search again")
    func test_givenSameText_whenSearch_thenNotDebounced() {
        // arrange
        let sut = makeSUT(useCase: AccountListUseCaseFake(results: []))

        // act
        sut.onSearch("")

        // assert
        #expect(debounce.actions.isEmpty)
    }

    @Test("the debounced search loads the first page for the last text")
    func test_givenTyping_whenDebounceFires_thenSearchesLastText() async throws {
        // arrange
        let useCase = AccountListUseCaseFake(results: [.success(.stub(accounts: []))])
        let sut = makeSUT(useCase: useCase)
        sut.onSearch("f")
        sut.onSearch("fond")

        // act
        let action = try #require(debounce.actions.last)
        await action()

        // assert
        #expect(await useCase.calls == [.init(page: 0, query: "fond")])
        #expect(sut.state.contentModel?.body == .noResults(query: "fond"))
    }

    @Test("tapping an account routes to its detail")
    func test_givenAccount_whenTap_thenRouted() {
        // arrange
        let sut = makeSUT(useCase: AccountListUseCaseFake(results: []))

        // act
        sut.onAccountTap(id: "000000-2906478309")

        // assert
        #expect(router.selectedIDs == ["000000-2906478309"])
    }

    private func makeSUT(useCase: AccountListUseCaseFake) -> AccountListViewModel {
        AccountListViewModel(
            router: router,
            getAccounts: useCase,
            debounce: debounce,
            contentConverter: contentConverter,
            errorConverter: ErrorViewModelConverterStub()
        )
    }
}
