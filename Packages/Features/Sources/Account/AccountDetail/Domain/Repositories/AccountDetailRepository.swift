import Pipeline

protocol AccountDetailRepository: Sendable {
    func download(id: String) async
    func observe() async -> any NetworkStatePipeline<AccountDetailEntity>
}
