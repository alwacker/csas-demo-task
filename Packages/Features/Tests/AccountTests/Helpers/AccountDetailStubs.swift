import Foundation
import Models
@testable import Account

extension AccountDetailModel {
    static func stub(balance: Decimal = 1000, currency: String? = "CZK") -> AccountDetailModel {
        AccountDetailModel(
            accountNumber: "000000-2906478309",
            bankCode: "0800",
            transparencyFrom: .gmt(2013, 6, 18),
            transparencyTo: .gmt(3000, 1, 1),
            publicationTo: .gmt(3000, 1, 1),
            actualizationDate: .gmt(2018, 1, 17),
            balance: balance,
            currency: currency,
            name: "Account",
            description: "Purpose",
            note: "Note",
            iban: "CZ75 0800 0000 0029 0647 8309"
        )
    }
}

extension AccountDetailEntity {
    static func stub(
        transparencyTo: Date = .gmt(3000, 1, 1),
        value: Decimal = 1000,
        name: String = "Account",
        description: String? = "Purpose",
        note: String? = "Note"
    ) -> AccountDetailEntity {
        AccountDetailEntity(
            accountNumber: "000000-2906478309",
            bankCode: "0800",
            transparencyFrom: .gmt(2013, 6, 18),
            transparencyTo: transparencyTo,
            publicationTo: .gmt(3000, 1, 1),
            actualizationDate: .gmt(2018, 1, 17),
            amount: Amount(value: value, currency: .czk),
            name: name,
            description: description,
            note: note,
            iban: "CZ75 0800 0000 0029 0647 8309"
        )
    }
}
