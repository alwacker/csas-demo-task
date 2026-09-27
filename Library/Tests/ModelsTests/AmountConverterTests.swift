import Foundation
import Testing
@testable import Models

@Suite("AmountConverter")
struct AmountConverterTests {
    @Test("keeps the value and the payload currency")
    func test_givenCurrency_whenConvert_thenUsesIt() throws {
        // arrange
        let sut = AmountConverterImp()
        let value = try #require(Decimal(string: "165939.97"))

        // act
        let result = sut.convert(value: value, currency: "EUR")

        // assert
        #expect(result == Amount(value: value, currency: Currency(code: "EUR")))
    }

    @Test("a missing currency falls back to CZK")
    func test_givenNoCurrency_whenConvert_thenCZK() {
        // arrange
        let sut = AmountConverterImp()

        // act
        let result = sut.convert(value: 7231.38, currency: nil)

        // assert
        #expect(result.currency == .czk)
    }
}
