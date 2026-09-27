import Models
import Testing
@testable import Account

@Suite("AccountDetailConverter")
struct AccountDetailConverterTests {
    @Test("maps the model fields and builds the amount from balance and currency")
    func test_givenModel_whenConvert_thenEntity() {
        // arrange
        let sut = AccountDetailConverterImp(amountConverter: AmountConverterStub())
        let model = AccountDetailModel.stub(balance: 12.5, currency: "EUR")

        // act
        let result = sut.convert(model)

        // assert
        #expect(result.accountNumber == model.accountNumber)
        #expect(result.bankCode == model.bankCode)
        #expect(result.transparencyFrom == model.transparencyFrom)
        #expect(result.transparencyTo == model.transparencyTo)
        #expect(result.publicationTo == model.publicationTo)
        #expect(result.actualizationDate == model.actualizationDate)
        #expect(result.name == model.name)
        #expect(result.description == model.description)
        #expect(result.note == model.note)
        #expect(result.iban == model.iban)
        #expect(result.amount == Amount(value: 12.5, currency: Currency(code: "EUR")))
    }
}
