struct APIErrorModel: Decodable, Sendable {
    struct Item: Decodable, Sendable {
        let error: String?
    }

    let status: Int?
    let errors: [Item]?
}
