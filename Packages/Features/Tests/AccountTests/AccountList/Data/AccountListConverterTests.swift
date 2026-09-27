import Testing
@testable import Account

@Suite("AccountListConverter")
struct AccountListConverterTests {
    private let sut = AccountListConverterImp(
        accountConverter: AccountConverterImp(amountConverter: AmountConverterStub())
    )

    @Test("next page comes from the model", arguments: [Optional(1), nil])
    func test_givenNextPage_whenConvert_thenPassedThrough(nextPage: Int?) {
        // arrange
        let model = AccountListModel(pageNumber: 0, nextPage: nextPage, recordCount: 0, accounts: [])

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.nextPage == nextPage)
    }

    @Test("keeps the record count and converts every account in order")
    func test_givenAccounts_whenConvert_thenAllConverted() {
        // arrange
        let model = AccountListModel(
            pageNumber: 0,
            nextPage: nil,
            recordCount: 2,
            accounts: [.stub(accountNumber: "1"), .stub(accountNumber: "2")]
        )

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.recordCount == 2)
        #expect(result.accounts.map(\.accountNumber) == ["1", "2"])
    }
}
