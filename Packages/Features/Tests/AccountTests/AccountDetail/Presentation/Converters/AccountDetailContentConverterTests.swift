import Foundation
import SharedExtensions
import Testing
import UIComponents
@testable import Account

@Suite("AccountDetailContentConverter")
struct AccountDetailContentConverterTests {
    private let sut = AccountDetailContentConverterImp(
        amountFormatter: AmountFormatterStub(),
        accountNumberFormatter: AccountNumberFormatterStub(),
        dateFormatter: DateTextFormatterImp(
            locale: Locale(identifier: "en_US"),
            monthLocale: Locale(identifier: "en_US"),
            timeZone: .gmt
        )
    )

    @Test("header has trimmed name, status and formatted balance")
    func test_givenAccount_whenConvert_thenHeader() {
        // act
        let result = sut.convert(account: .stub(value: -12.5, name: "  Name \n"), transactions: .stub(transactions: []), previous: nil)

        // assert
        #expect(result.header == AccountDetailHeader(name: "Name", status: .active, balance: AmountFormatterStub.amount(-12.5)))
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
        let result = sut.convert(account: .stub(transparencyTo: transparencyTo), transactions: .stub(transactions: []), previous: nil)

        // assert
        #expect(result.header.status == expected)
    }

    @Test("sections go account, about, transparency with formatted dates")
    func test_givenFullAccount_whenConvert_thenSections() throws {
        // act
        let result = sut.convert(account: .stub(), transactions: .stub(transactions: []), previous: nil)

        // assert
        #expect(result.sections.count == 3)
        #expect(result.sections[0].rows.map(\.value) == ["000000-2906478309/0800", "CZ75 0800 0000 0029 0647 8309"])
        #expect(result.sections[0].rows.map(\.isCopyable) == [true, true])
        #expect(result.sections[1].rows.map(\.value) == ["Purpose", "Note"])
        #expect(Array(result.sections[2].rows.map(\.value).prefix(3)) == ["6/18/2013", "1/1/3000", "1/1/3000"])
    }

    @Test("about section is left out without purpose and note")
    func test_givenNoPurposeAndNote_whenConvert_thenNoAboutSection() {
        // act
        let result = sut.convert(account: .stub(description: nil, note: nil), transactions: .stub(transactions: []), previous: nil)

        // assert
        #expect(result.sections.count == 2)
        #expect(!result.sections.flatMap(\.rows).map(\.value).contains("Purpose"))
    }

    @Test("transactions of one month share a group, a new month starts a new one")
    func test_givenTwoMonths_whenConvert_thenTwoGroups() {
        // arrange
        let transactions = TransactionListEntity.stub(transactions: [
            .stub(processingDate: .gmt(2018, 1, 1)),
            .stub(processingDate: .gmt(2017, 12, 31)),
            .stub(processingDate: .gmt(2017, 12, 1))
        ])

        // act
        let result = sut.convert(account: .stub(), transactions: transactions, previous: nil)

        // assert
        #expect(result.transactions.map(\.title) == ["January 2018", "December 2017"])
        #expect(result.transactions.map(\.rows.count) == [1, 2])
    }

    @Test("the next page continues the last month group and keeps ids unique")
    func test_givenPrevious_whenConvert_thenGroupContinued() {
        // arrange
        let first = sut.convert(
            account: .stub(),
            transactions: .stub(transactions: [.stub(processingDate: .gmt(2017, 12, 31))], nextPage: 1),
            previous: nil
        )

        // act
        let result = sut.convert(
            account: .stub(),
            transactions: .stub(transactions: [.stub(processingDate: .gmt(2017, 12, 1)), .stub(processingDate: .gmt(2017, 11, 24))]),
            previous: first
        )

        // assert
        #expect(first.hasMoreTransactions)
        #expect(result.transactions.map(\.title) == ["December 2017", "November 2017"])
        #expect(result.transactions.flatMap(\.rows).map(\.id) == [0, 1, 2])
        #expect(result.hasMoreTransactions == false)
    }

    @Test("a named counterparty is the title and the type becomes a chip")
    func test_givenCounterparty_whenConvert_thenTitleAndChip() throws {
        // act
        let result = sut.convert(
            account: .stub(),
            transactions: .stub(transactions: [.stub(counterpartyName: "MF", message: "Dar")]),
            previous: nil
        )

        // assert
        let row = try #require(result.transactions.first?.rows.first)
        #expect(row.title == "MF")
        #expect(row.category == "Úhrada")
        #expect(row.message == "Dar")
        #expect(row.date == "1/1/2018")
    }

    @Test("without a counterparty the trimmed type is the title, with no chip")
    func test_givenNoCounterparty_whenConvert_thenTypeIsTitle() throws {
        // act
        let result = sut.convert(
            account: .stub(),
            transactions: .stub(transactions: [.stub(typeDescription: "Poplatky ", counterpartyName: nil)]),
            previous: nil
        )

        // assert
        let row = try #require(result.transactions.first?.rows.first)
        #expect(row.title == "Poplatky")
        #expect(row.category == nil)
    }

    @Test("direction and amount come from the value's sign")
    func test_givenSignedValues_whenConvert_thenDirection() {
        // act
        let result = sut.convert(
            account: .stub(),
            transactions: .stub(transactions: [.stub(value: 125000), .stub(value: -2.5)]),
            previous: nil
        )

        // assert
        let rows = result.transactions.flatMap(\.rows)
        #expect(rows.map(\.direction) == [.incoming, .outgoing])
        #expect(rows.map(\.amount) == ["125000 CZK", "-2.5 CZK"])
    }
}
