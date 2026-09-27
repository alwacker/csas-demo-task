import Localization
import Testing

@Suite("Localization")
struct LocalizationTests {
    @Test("a key resolves to its catalog text")
    func test_givenKey_whenResolved_thenCatalogText() {
        // act
        let result = Localization.AccountList.title

        // assert
        #expect(result == "Accounts")
    }

    @Test("the subtitle picks the plural form", arguments: [(1, "1 account"), (5, "5 accounts")])
    func test_givenCount_whenSubtitle_thenPluralForm(count: Int, expected: String) {
        // act
        let result = Localization.AccountList.subtitle(count: count)

        // assert
        #expect(result == expected)
    }

    @Test("arguments are inserted into the text")
    func test_givenLabel_whenCopy_thenLabelInserted() {
        // act
        let result = Localization.Common.copy("IBAN")

        // assert
        #expect(result == "Copy IBAN")
    }
}
