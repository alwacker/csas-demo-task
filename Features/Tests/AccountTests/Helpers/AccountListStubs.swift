import Foundation
import Models
import SharedExtensions
@testable import Account

extension AccountModel {
    static func stub(
        accountNumber: String = "000000-2906478309",
        transparencyTo: Date = .gmt(3000, 1, 1),
        balance: Decimal = 1000,
        currency: String? = "CZK",
        name: String = "Account",
        description: String? = "Purpose"
    ) -> AccountModel {
        AccountModel(
            accountNumber: accountNumber,
            bankCode: "0800",
            transparencyFrom: .gmt(2013, 6, 18),
            transparencyTo: transparencyTo,
            publicationTo: .gmt(3000, 1, 1),
            actualizationDate: .gmt(2018, 1, 17),
            balance: balance,
            currency: currency,
            name: name,
            description: description,
            note: nil,
            iban: "CZ75 0800 0000 0029 0647 8309"
        )
    }
}

extension AccountEntity {
    static func stub(
        accountNumber: String = "000000-2906478309",
        transparencyTo: Date = .gmt(3000, 1, 1),
        value: Decimal = 1000,
        name: String = "Account",
        description: String? = "Purpose"
    ) -> AccountEntity {
        AccountEntity(
            accountNumber: accountNumber,
            bankCode: "0800",
            transparencyFrom: .gmt(2013, 6, 18),
            transparencyTo: transparencyTo,
            publicationTo: .gmt(3000, 1, 1),
            actualizationDate: .gmt(2018, 1, 17),
            amount: Amount(value: value, currency: .czk),
            name: name,
            description: description,
            note: nil,
            iban: "CZ75 0800 0000 0029 0647 8309"
        )
    }
}

extension AccountListEntity {
    static func stub(pageNumber: Int = 0, accounts: [AccountEntity], nextPage: Int? = nil) -> AccountListEntity {
        AccountListEntity(pageNumber: pageNumber, recordCount: accounts.count, nextPage: nextPage, accounts: accounts)
    }
}

struct AmountConverterStub: AmountConverter {
    func convert(value: Decimal, currency: String?) -> Amount {
        Amount(value: value, currency: Currency(code: currency ?? "NONE"))
    }
}

struct AmountFormatterStub: AmountFormatter {
    func format(_ value: Decimal, currencyCode: String) -> FormattedAmount {
        FormattedAmount(
            integer: "\(value)",
            fraction: "",
            currency: " \(currencyCode)",
            text: "\(value) \(currencyCode)",
            isNegative: value < 0
        )
    }

    static func amount(_ value: Decimal, currencyCode: String = "CZK") -> FormattedAmount {
        AmountFormatterStub().format(value, currencyCode: currencyCode)
    }
}

struct AccountNumberFormatterStub: AccountNumberFormatter {
    func format(accountNumber: String, bankCode: String) -> String {
        "\(accountNumber)/\(bankCode)"
    }
}

struct ErrorViewModelConverterStub: ErrorViewModelConverter {
    static let model = ErrorViewModel(title: "Error", message: "Message")

    func convert(error: any Error) -> ErrorViewModel {
        Self.model
    }
}
