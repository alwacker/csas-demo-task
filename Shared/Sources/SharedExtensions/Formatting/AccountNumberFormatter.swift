public protocol AccountNumberFormatter: Sendable {
    func format(accountNumber: String, bankCode: String) -> String
}

public struct AccountNumberFormatterImp: AccountNumberFormatter {
    public init() {}

    public func format(accountNumber: String, bankCode: String) -> String {
        let parts = accountNumber
            .split(separator: "-")
            .map { String($0.drop { $0 == "0" }) }
            .filter { !$0.isEmpty }
        return parts.joined(separator: "-") + "/" + bankCode
    }
}
