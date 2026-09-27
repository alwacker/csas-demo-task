import Foundation
import Networking
import Testing
@testable import Account

@Suite("TransactionListModel decoding")
struct TransactionListModelDecodingTests {
    private static let json = """
    {
      "pageNumber": 0, "pageSize": 50, "pageCount": 2, "nextPage": 1, "recordCount": 73,
      "transactions": [
        {
          "amount": { "value": -1.21, "precision": 0, "currency": "CZK" },
          "type": "40900", "dueDate": "2017-12-31T00:00:00", "processingDate": "2018-01-01T00:00:00",
          "sender": { "accountNumber": "000000-0000000000", "bankCode": "0800", "iban": "CZ13 0800 0000 0029 0647 8309",
                      "specificSymbol": "0000000000", "specificSymbolParty": "0000000000", "constantSymbol": "0000" },
          "receiver": { "accountNumber": "000000-2906478309", "bankCode": "0800", "iban": "CZ13 0800 0000 0029 0647 8309" },
          "typeDescription": "Daň z úroku"
        },
        {
          "amount": { "value": -92, "precision": 0, "currency": "CZK" },
          "type": "60000", "dueDate": "2017-12-31T00:00:00", "processingDate": "2018-01-01T00:00:00",
          "sender": { "accountNumber": "000000-0000000000", "bankCode": "0800", "iban": "CZ13 0800 0000 0029 0647 8309",
                      "constantSymbol": "0158", "description": "(01.12.2017 - 31.12.2017)" },
          "receiver": { "accountNumber": "000000-2906478309", "bankCode": "0800", "iban": "CZ13 0800 0000 0029 0647 8309" },
          "typeDescription": "Poplatky "
        },
        {
          "amount": { "value": 10000, "precision": 0, "currency": "CZK" },
          "type": "80110", "dueDate": "2017-05-30T00:00:00", "processingDate": "2017-05-30T00:00:00",
          "sender": { "accountNumber": "000000-0802657012", "bankCode": "2700", "iban": "CZ19 0270 0000 0008 0265 7012",
                      "variableSymbol": "12345", "constantSymbol": "2345", "name": "ALUCON S.R.O.", "description": "Dar" },
          "receiver": { "accountNumber": "000000-2906478309", "bankCode": "0800", "iban": "CZ13 0800 0000 0029 0647 8309" },
          "typeDescription": "Úhrada"
        }
      ]
    }
    """

    @Test("decodes every payload variant of a real response")
    func test_givenRealPayload_whenDecode_thenAllVariantsDecoded() throws {
        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(TransactionListModel.self, from: Data(Self.json.utf8))

        // assert
        #expect(result.pageNumber == 0)
        #expect(result.nextPage == 1)
        #expect(result.transactions[2].processingDate == Date(timeIntervalSince1970: 1_496_095_200))
        #expect(result.transactions.count == 3)
        #expect(result.transactions[0].sender == .init(name: nil, description: nil))
        #expect(result.transactions[1].sender == .init(name: nil, description: "(01.12.2017 - 31.12.2017)"))
        #expect(result.transactions[2].sender == .init(name: "ALUCON S.R.O.", description: "Dar"))
        #expect(result.transactions[1].typeDescription == "Poplatky ")
    }

    @Test("amount keeps exact decimal precision (D-3)")
    func test_givenFractionalAmount_whenDecode_thenExactDecimal() throws {
        // arrange
        let expected = try #require(Decimal(string: "-1.21"))

        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(TransactionListModel.self, from: Data(Self.json.utf8))

        // assert
        #expect(result.transactions.first?.amount.value == expected)
    }

    @Test("only amount and processingDate are required")
    func test_givenMinimalTransaction_whenDecode_thenOptionalsNil() throws {
        // arrange
        let json = #"{ "amount": { "value": 5 }, "processingDate": "2018-01-01T00:00:00" }"#

        // act
        let result = try JSONDecoder.makeAPIDecoder().decode(TransactionModel.self, from: Data(json.utf8))

        // assert
        #expect(result.amount.currency == nil)
        #expect(result.typeDescription == nil)
        #expect(result.sender == nil)
    }
}
