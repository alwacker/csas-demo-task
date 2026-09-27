import Foundation

struct TransactionModel: Decodable, Sendable, Equatable {
    let amount: TransactionAmountModel
    let processingDate: Date
    let typeDescription: String?
    let sender: TransactionSenderModel?
}
