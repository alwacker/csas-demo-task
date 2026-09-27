import Foundation

struct AccountDetailModel: Decodable, Sendable, Equatable {
    let accountNumber: String
    let bankCode: String
    let transparencyFrom: Date
    let transparencyTo: Date
    let publicationTo: Date
    let actualizationDate: Date
    let balance: Decimal
    let currency: String?
    let name: String
    let description: String?
    let note: String?
    let iban: String
}
