import Testing
@testable import SharedExtensions

@Suite("AccountNumberFormatter")
struct AccountNumberFormatterTests {
    private static let cases: [(String, String)] = [
        ("000000-2906478309", "2906478309/0800"),
        ("000027-2000709369", "27-2000709369/0800"),
        ("000182-0388063349", "182-388063349/0800"),
        ("2906478309", "2906478309/0800")
    ]

    @Test("drops leading zeros and an empty prefix", arguments: cases)
    func test_givenRawNumber_whenFormat_thenDomesticNotation(accountNumber: String, expected: String) {
        // arrange
        let sut = AccountNumberFormatterImp()

        // act
        let result = sut.format(accountNumber: accountNumber, bankCode: "0800")

        // assert
        #expect(result == expected)
    }
}
