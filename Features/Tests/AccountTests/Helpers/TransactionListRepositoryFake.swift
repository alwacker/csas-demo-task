import Pipeline
@testable import Account

actor TransactionListRepositoryFake: TransactionListRepository {
    struct Download: Equatable {
        let id: String
        let page: Int
    }

    private(set) var downloads: [Download] = []
    private let result: NetworkRepositoryState<TransactionListEntity>
    private let state = StatePipeline<NetworkRepositoryState<TransactionListEntity>>(value: .loading)

    init(result: NetworkRepositoryState<TransactionListEntity>) {
        self.result = result
    }

    func download(id: String, page: Int) async {
        downloads.append(Download(id: id, page: page))
        await state.send(value: result)
    }

    func observe() async -> any NetworkStatePipeline<TransactionListEntity> {
        state
    }
}
