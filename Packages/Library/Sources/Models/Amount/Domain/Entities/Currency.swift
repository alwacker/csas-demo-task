public struct Currency: Equatable, Sendable {
    public let code: String

    public init(code: String) {
        self.code = code
    }
}

public extension Currency {
    static var czk: Currency {
        Currency(code: "CZK")
    }
}
