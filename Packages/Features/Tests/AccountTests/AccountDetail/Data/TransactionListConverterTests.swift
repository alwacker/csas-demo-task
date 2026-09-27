import Testing
@testable import Account

@Suite("TransactionListConverter")
struct TransactionListConverterTests {
    private let sut = TransactionListConverterImp(
        transactionConverter: TransactionConverterImp(amountConverter: AmountConverterStub())
    )

    @Test("page and next page come from the model", arguments: [Optional(2), nil])
    func test_givenNextPage_whenConvert_thenPassedThrough(nextPage: Int?) {
        // arrange
        let model = TransactionListModel(pageNumber: 1, nextPage: nextPage, transactions: [])

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.pageNumber == 1)
        #expect(result.nextPage == nextPage)
    }

    @Test("converts every transaction in order")
    func test_givenTransactions_whenConvert_thenAllConverted() {
        // arrange
        let model = TransactionListModel(pageNumber: 0, nextPage: nil, transactions: [.stub(value: 1), .stub(value: 2)])

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.transactions.map(\.amount.value) == [1, 2])
    }
}
