import Foundation
import SharedExtensions
import Testing

@Suite("AmountFormatter")
struct AmountFormatterTests {
    private static let cases: [(String, String)] = [
        ("1063961.87", "1 063 961,87 Kč"),
        ("820.23", "820,23 Kč"),
        ("0", "0,00 Kč"),
        ("-1234.5", "-1 234,50 Kč")
    ]

    @Test("formats CZK in Czech notation", arguments: cases)
    func test_givenDecimal_whenFormat_thenCzechNotation(value: String, expected: String) throws {
        // arrange
        let sut = AmountFormatterImp()
        let decimal = try #require(Decimal(string: value))

        // act
        let result = sut.format(decimal, currencyCode: "CZK")

        // assert
        #expect(normalized(result.text) == expected)
    }

    @Test("splits the text into integer with separator, fraction and currency")
    func test_givenDecimal_whenFormat_thenParts() throws {
        // arrange
        let sut = AmountFormatterImp()
        let decimal = try #require(Decimal(string: "1063961.87"))

        // act
        let result = sut.format(decimal, currencyCode: "CZK")

        // assert
        #expect(normalized(result.integer) == "1 063 961,")
        #expect(result.fraction == "87")
        #expect(normalized(result.currency) == " Kč")
        #expect(result.integer + result.fraction + result.currency == result.text)
    }

    @Test("marks negative values", arguments: [("-1", true), ("0", false), ("1", false)])
    func test_givenSign_whenFormat_thenIsNegative(value: String, expected: Bool) throws {
        // arrange
        let sut = AmountFormatterImp()
        let decimal = try #require(Decimal(string: value))

        // act
        let result = sut.format(decimal, currencyCode: "CZK")

        // assert
        #expect(result.isNegative == expected)
    }

    private func normalized(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\u{00A0}", with: " ")
            .replacingOccurrences(of: "\u{202F}", with: " ")
            .replacingOccurrences(of: "\u{2212}", with: "-")
    }
}
