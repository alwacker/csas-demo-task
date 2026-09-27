import Foundation

struct TransactionAmountModel: Decodable, Sendable, Equatable {
    let value: Decimal
    let currency: String?
}
