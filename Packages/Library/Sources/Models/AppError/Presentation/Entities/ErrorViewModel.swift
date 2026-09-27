public struct ErrorViewModel: Equatable, Sendable {
    public let title: String
    public let message: String
    public let code: String?

    public init(title: String, message: String, code: String? = nil) {
        self.title = title
        self.message = message
        self.code = code
    }
}
