import Pipeline

protocol TransactionListRepository: Sendable {
    func download(id: String, page: Int) async
    func observe() async -> any NetworkStatePipeline<TransactionListEntity>
}
