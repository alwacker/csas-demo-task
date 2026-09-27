import Foundation
import SharedExtensions
import Testing
import UIComponents
@testable import Account

@Suite("AccountListContentConverter")
struct AccountListContentConverterTests {
    private typealias Row = AccountListViewModel.Content.Row

    private let sut = AccountListContentConverterImp(
        amountFormatter: AmountFormatterStub(),
        accountNumberFormatter: AccountNumberFormatterStub()
    )

    @Test("builds a row with trimmed name and formatted values")
    func test_givenAccount_whenConvert_thenRowFormatted() {
        // arrange
        let entity = AccountListEntity.stub(accounts: [.stub(value: -12.5, name: "  Name \n", description: "Purpose")])

        // act
        let result = sut.convert(entity, previous: nil, query: "")

        // assert
        let row = Row(
            id: "000000-2906478309",
            name: "Name",
            status: .active,
            accountNumber: "000000-2906478309/0800",
            balance: AmountFormatterStub.amount(-12.5),
            purpose: "Purpose"
        )
        #expect(result.body == .accounts([row], hasMore: false))
    }

    @Test("appends the page's rows to the rows already on screen")
    func test_givenPrevious_whenConvert_thenRowsAppended() {
        // arrange
        let first = sut.convert(.stub(accounts: [.stub(accountNumber: "1")], nextPage: 1), previous: nil, query: "")

        // act
        let result = sut.convert(.stub(accounts: [.stub(accountNumber: "2")]), previous: first, query: "")

        // assert
        guard case let .accounts(rows, hasMore) = result.body else {
            Issue.record("expected accounts, got \(result.body)")
            return
        }
        #expect(rows.map(\.id) == ["1", "2"])
        #expect(hasMore == false)
    }

    @Test("a next page means more rows to load")
    func test_givenNextPage_whenConvert_thenHasMore() {
        // act
        let result = sut.convert(.stub(accounts: [.stub()], nextPage: 1), previous: nil, query: "")

        // assert
        guard case let .accounts(_, hasMore) = result.body else {
            Issue.record("expected accounts, got \(result.body)")
            return
        }
        #expect(hasMore)
    }

    @Test("an empty search result shows no results for the query")
    func test_givenQueryAndNoAccounts_whenConvert_thenNoResults() {
        // act
        let result = sut.convert(.stub(accounts: []), previous: nil, query: "xyz")

        // assert
        #expect(result.body == .noResults(query: "xyz"))
    }

    @Test("an empty list without a query stays a list")
    func test_givenNoQueryAndNoAccounts_whenConvert_thenEmptyList() {
        // act
        let result = sut.convert(.stub(accounts: []), previous: nil, query: "")

        // assert
        #expect(result.body == .accounts([], hasMore: false))
    }

    @Test(
        "an account is active until its transparency ends",
        arguments: [
            (transparencyTo: Date.gmt(3000, 1, 1), expected: AccountStatus.active),
            (transparencyTo: Date.gmt(2000, 1, 1), expected: .closed)
        ]
    )
    func test_givenTransparencyTo_whenConvert_thenStatus(transparencyTo: Date, expected: AccountStatus) {
        // act
        let result = sut.convert(.stub(accounts: [.stub(transparencyTo: transparencyTo)]), previous: nil, query: "")

        // assert
        guard case let .accounts(rows, _) = result.body else {
            Issue.record("expected accounts, got \(result.body)")
            return
        }
        #expect(rows.first?.status == expected)
    }
}
