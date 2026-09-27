import Foundation
import Models
import SharedExtensions
import Testing
import UIComponents
@testable import Account

@MainActor
@Suite("AccountDetailViewModel")
struct AccountDetailViewModelTests {
    private static let id = "000000-2906478309"

    private let contentConverter = AccountDetailContentConverterImp(
        amountFormatter: AmountFormatterStub(),
        accountNumberFormatter: AccountNumberFormatterStub(),
        dateFormatter: DateTextFormatterImp(timeZone: .gmt)
    )

    @Test("load shows the account with its first transactions")
    func test_givenData_whenLoad_thenContent() async {
        // arrange
        let account = AccountDetailEntity.stub()
        let transactions = TransactionListEntity.stub(transactions: [.stub()], nextPage: 1)
        let getAccount = AccountDetailUseCaseFake(results: [.success(account)])
        let getTransactions = TransactionListUseCaseFake(results: [.success(transactions)])
        let sut = makeSUT(getAccount: getAccount, getTransactions: getTransactions)

        // act
        await sut.onLoad()

        // assert
        #expect(sut.state == .content(contentConverter.convert(account: account, transactions: transactions, previous: nil)))
        #expect(await getAccount.requestedIDs == [Self.id])
        #expect(await getTransactions.requestedPages == [0])
    }

    @Test(
        "a failure of either request shows the error",
        arguments: [
            (accountFails: true, transactionsFail: false),
            (accountFails: false, transactionsFail: true)
        ]
    )
    func test_givenOneFailure_whenLoad_thenError(accountFails: Bool, transactionsFail: Bool) async {
        // arrange
        let sut = makeSUT(
            getAccount: AccountDetailUseCaseFake(results: [accountFails ? .failure(.notFound) : .success(.stub())]),
            getTransactions: TransactionListUseCaseFake(results: [transactionsFail ? .failure(.offline) : .success(.stub(transactions: []))])
        )

        // act
        await sut.onLoad()

        // assert
        #expect(sut.state == .error(ErrorViewModelConverterStub.model))
    }

    @Test("reaching the end appends the next page of transactions")
    func test_givenNextPage_whenReachedEnd_thenAppended() async {
        // arrange
        let getTransactions = TransactionListUseCaseFake(results: [
            .success(.stub(transactions: [.stub()], nextPage: 1)),
            .success(.stub(transactions: [.stub()]))
        ])
        let sut = makeSUT(
            getAccount: AccountDetailUseCaseFake(results: [.success(.stub())]),
            getTransactions: getTransactions
        )
        await sut.onLoad()

        // act
        await sut.onReachedEnd()

        // assert
        #expect(sut.state.contentModel?.transactions.flatMap(\.rows).count == 2)
        #expect(sut.state.contentModel?.hasMoreTransactions == false)
        #expect(await getTransactions.requestedPages == [0, 1])
    }

    @Test("reaching the end of the last page loads nothing")
    func test_givenNoNextPage_whenReachedEnd_thenNoRequest() async {
        // arrange
        let getTransactions = TransactionListUseCaseFake(results: [.success(.stub(transactions: [.stub()]))])
        let sut = makeSUT(
            getAccount: AccountDetailUseCaseFake(results: [.success(.stub())]),
            getTransactions: getTransactions
        )
        await sut.onLoad()

        // act
        await sut.onReachedEnd()

        // assert
        #expect(await getTransactions.requestedPages == [0])
    }

    @Test("retry after an error shows the account")
    func test_givenError_whenRetry_thenContent() async {
        // arrange
        let sut = makeSUT(
            getAccount: AccountDetailUseCaseFake(results: [.failure(.offline), .success(.stub())]),
            getTransactions: TransactionListUseCaseFake(results: [.success(.stub(transactions: [])), .success(.stub(transactions: []))])
        )
        await sut.onLoad()

        // act
        await sut.onRetry()

        // assert
        #expect(sut.state.contentModel != nil)
    }

    private func makeSUT(
        getAccount: AccountDetailUseCaseFake,
        getTransactions: TransactionListUseCaseFake
    ) -> AccountDetailViewModel {
        AccountDetailViewModel(
            id: Self.id,
            getAccount: getAccount,
            getTransactions: getTransactions,
            contentConverter: contentConverter,
            errorConverter: ErrorViewModelConverterStub()
        )
    }
}
