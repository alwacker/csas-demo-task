import Pipeline
@testable import Account

actor AccountDetailRepositoryFake: AccountDetailRepository {
    private(set) var downloadedIDs: [String] = []
    private let result: NetworkRepositoryState<AccountDetailEntity>
    private let state = StatePipeline<NetworkRepositoryState<AccountDetailEntity>>(value: .loading)

    init(result: NetworkRepositoryState<AccountDetailEntity>) {
        self.result = result
    }

    func download(id: String) async {
        downloadedIDs.append(id)
        await state.send(value: result)
    }

    func observe() async -> any NetworkStatePipeline<AccountDetailEntity> {
        state
    }
}
