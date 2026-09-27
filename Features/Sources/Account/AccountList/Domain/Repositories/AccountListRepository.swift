import Pipeline

protocol AccountListRepository: Sendable {
    func download(page: Int, filter: String?) async
    func observe() async -> any NetworkStatePipeline<AccountListEntity>
}
