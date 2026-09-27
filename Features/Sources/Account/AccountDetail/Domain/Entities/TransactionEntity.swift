import Foundation
import Models

struct TransactionEntity: Sendable, Equatable {
    let amount: Amount
    let processingDate: Date
    let typeDescription: String?
    let counterpartyName: String?
    let message: String?
}
