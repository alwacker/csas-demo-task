import Foundation
import Models
@testable import Account

extension TransactionModel {
    static func stub(
        value: Decimal = 10000,
        currency: String? = "CZK",
        sender: TransactionSenderModel? = TransactionSenderModel(name: "ALUCON S.R.O.", description: "Dar")
    ) -> TransactionModel {
        TransactionModel(
            amount: TransactionAmountModel(value: value, currency: currency),
            processingDate: .gmt(2017, 5, 30),
            typeDescription: "Úhrada",
            sender: sender
        )
    }
}

extension TransactionEntity {
    static func stub(
        value: Decimal = 100,
        processingDate: Date = .gmt(2018, 1, 1),
        typeDescription: String? = "Úhrada",
        counterpartyName: String? = "MF",
        message: String? = nil
    ) -> TransactionEntity {
        TransactionEntity(
            amount: Amount(value: value, currency: .czk),
            processingDate: processingDate,
            typeDescription: typeDescription,
            counterpartyName: counterpartyName,
            message: message
        )
    }
}

extension TransactionListEntity {
    static func stub(pageNumber: Int = 0, transactions: [TransactionEntity], nextPage: Int? = nil) -> TransactionListEntity {
        TransactionListEntity(pageNumber: pageNumber, nextPage: nextPage, transactions: transactions)
    }
}
