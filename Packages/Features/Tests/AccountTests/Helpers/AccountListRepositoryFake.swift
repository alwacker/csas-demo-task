import Pipeline
@testable import Account

actor AccountListRepositoryFake: AccountListRepository {
    struct Download: Equatable {
        let page: Int
        let filter: String?
    }

    private(set) var downloads: [Download] = []
    private let result: NetworkRepositoryState<AccountListEntity>
    private let state = StatePipeline<NetworkRepositoryState<AccountListEntity>>(value: .loading)

    init(result: NetworkRepositoryState<AccountListEntity>) {
        self.result = result
    }

    func download(page: Int, filter: String?) async {
        downloads.append(Download(page: page, filter: filter))
        await state.send(value: result)
    }

    func observe() async -> any NetworkStatePipeline<AccountListEntity> {
        state
    }
}
