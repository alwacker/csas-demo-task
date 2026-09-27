import Foundation

public enum APIEndpoint: Sendable, Equatable {
    case accountList
    case accountDetail(id: String)
    case accountTransactions(id: String)

    public var path: String {
        switch self {
        case .accountList:
            "/transparentAccounts"
        case let .accountDetail(id):
            "/transparentAccounts/\(id)"
        case let .accountTransactions(id):
            "/transparentAccounts/\(id)/transactions/"
        }
    }
}
