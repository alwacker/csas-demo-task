import Foundation
import Models

struct AccountDetailEntity: Sendable, Equatable {
    let accountNumber: String
    let bankCode: String
    let transparencyFrom: Date
    let transparencyTo: Date
    let publicationTo: Date
    let actualizationDate: Date
    let amount: Amount
    let name: String
    let description: String?
    let note: String?
    let iban: String
}
