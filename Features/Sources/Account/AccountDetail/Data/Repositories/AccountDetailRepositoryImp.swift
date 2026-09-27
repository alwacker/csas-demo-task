import Models
import Networking
import Pipeline

actor AccountDetailRepositoryImp: AccountDetailRepository {
    private let apiProvider: any APIProvider
    private let converter: any AccountDetailConverter
    private let errorConverter: any DomainErrorConverter
    private let state = StatePipeline<NetworkRepositoryState<AccountDetailEntity>>(value: .loading)

    init(
        apiProvider: any APIProvider,
        converter: any AccountDetailConverter,
        errorConverter: any DomainErrorConverter
    ) {
        self.apiProvider = apiProvider
        self.converter = converter
        self.errorConverter = errorConverter
    }

    func download(id: String) async {
        await state.send(value: .loading)

        do {
            let result: AccountDetailModel = try await apiProvider.request(endpoint: .accountDetail(id: id))
            let data = converter.convert(result)
            try Task.checkCancellation()
            await state.send(value: .data(data))
        } catch {
            guard !Task.isCancelled else { return }
            await state.send(value: .error(errorConverter.convert(error: error)))
        }
    }

    func observe() async -> any NetworkStatePipeline<AccountDetailEntity> {
        state
    }
}
