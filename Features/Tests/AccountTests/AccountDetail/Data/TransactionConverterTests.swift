import Models
import Testing
@testable import Account

@Suite("TransactionConverter")
struct TransactionConverterTests {
    private let sut = TransactionConverterImp(amountConverter: AmountConverterStub())

    @Test("sender name is the counterparty, sender description is the message")
    func test_givenSender_whenConvert_thenCounterpartyAndMessage() {
        // act
        let result = sut.convert(.stub())

        // assert
        #expect(result == TransactionEntity(
            amount: Amount(value: 10000, currency: Currency(code: "CZK")),
            processingDate: .gmt(2017, 5, 30),
            typeDescription: "Úhrada",
            counterpartyName: "ALUCON S.R.O.",
            message: "Dar"
        ))
    }

    @Test("a transaction without sender has no counterparty and no message")
    func test_givenNoSender_whenConvert_thenNil() {
        // act
        let result = sut.convert(.stub(currency: nil, sender: nil))

        // assert
        #expect(result.counterpartyName == nil)
        #expect(result.message == nil)
        #expect(result.amount.currency == Currency(code: "NONE"))
    }
}
