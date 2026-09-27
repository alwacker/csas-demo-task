import Foundation
import Networking
import Testing
@testable import Account

@Suite("AccountModel decoding")
struct AccountModelDecodingTests {
    @Test("decodes a page from the API payload")
    func test_givenPayload_whenDecode_thenPageDecoded() throws {
        // arrange
        let json = """
        {
          "pageNumber": 0, "pageSize": 50, "pageCount": 3, "nextPage": 1, "recordCount": 120,
          "accounts": [{
            "accountNumber": "000000-2906478309", "bankCode": "0800",
            "transparencyFrom": "2013-06-18T00:00:00", "transparencyTo": "3000-01-01T00:00:00",
            "publicationTo": "3000-01-01T00:00:00", "actualizationDate": "2018-01-17T13:00:00",
            "balance": 1063961.87, "currency": "CZK", "name": "Společenství Praha 4",
            "description": "Fond oprav", "iban": "CZ75 0800 0000 0029 0647 8309"
          }]
        }
        """

        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(AccountListModel.self, from: Data(json.utf8))

        // assert
        #expect(result.pageNumber == 0)
        #expect(result.nextPage == 1)
        #expect(result.recordCount == 120)
        #expect(result.accounts.first?.name == "Společenství Praha 4")
        #expect(result.accounts.first?.description == "Fond oprav")
        #expect(result.accounts.first?.transparencyFrom == Date(timeIntervalSince1970: 1_371_506_400))
    }

    @Test("balance keeps exact decimal precision (D-3)")
    func test_givenFractionalBalance_whenDecode_thenExactDecimal() throws {
        // arrange
        let json = Self.account(extra: #""balance": 1063961.87, "currency": "CZK""#)
        let expected = try #require(Decimal(string: "1063961.87"))

        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(AccountModel.self, from: Data(json.utf8))

        // assert
        #expect(result.balance == expected)
    }

    @Test("optional fields missing in the payload decode as nil")
    func test_givenNoOptionalFields_whenDecode_thenNil() throws {
        // arrange
        let json = Self.account(extra: #""balance": 0"#)

        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(AccountModel.self, from: Data(json.utf8))

        // assert
        #expect(result.currency == nil)
        #expect(result.description == nil)
        #expect(result.note == nil)
    }

    private static func account(extra: String) -> String {
        """
        {
          "accountNumber": "000000-2906478309", "bankCode": "0800",
          "transparencyFrom": "2013-06-18T00:00:00", "transparencyTo": "3000-01-01T00:00:00",
          "publicationTo": "3000-01-01T00:00:00", "actualizationDate": "2018-01-17T13:00:00",
          "name": "Account", "iban": "CZ75 0800 0000 0029 0647 8309", \(extra)
        }
        """
    }
}
