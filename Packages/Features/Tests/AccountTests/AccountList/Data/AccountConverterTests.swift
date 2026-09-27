import Foundation
import Models
import Testing
@testable import Account

@Suite("AccountConverter")
struct AccountConverterTests {
    @Test("maps the model fields and builds the amount from balance and currency")
    func test_givenModel_whenConvert_thenEntity() {
        // arrange
        let sut = AccountConverterImp(amountConverter: AmountConverterStub())
        let model = AccountModel.stub(balance: 12.5, currency: "EUR", name: "Name", description: "Purpose")

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.accountNumber == model.accountNumber)
        #expect(result.bankCode == model.bankCode)
        #expect(result.transparencyTo == model.transparencyTo)
        #expect(result.name == "Name")
        #expect(result.description == "Purpose")
        #expect(result.iban == model.iban)
        #expect(result.amount == Amount(value: 12.5, currency: Currency(code: "EUR")))
    }

    @Test("passes a missing currency to the amount converter")
    func test_givenNoCurrency_whenConvert_thenAmountConverterDecides() {
        // arrange
        let sut = AccountConverterImp(amountConverter: AmountConverterStub())

        // act
        let result = sut.convert(.stub(currency: nil))

        // assert
        #expect(result.amount.currency == Currency(code: "NONE"))
    }
}
