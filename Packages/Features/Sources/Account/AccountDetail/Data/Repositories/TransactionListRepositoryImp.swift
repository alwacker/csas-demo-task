import Models
import Networking
import Pipeline

actor TransactionListRepositoryImp: TransactionListRepository {
    private let pageSize = 50
    private let apiProvider: any APIProvider
    private let converter: any TransactionListConverter
    private let errorConverter: any DomainErrorConverter
    private let state = StatePipeline<NetworkRepositoryState<TransactionListEntity>>(value: .loading)

    init(
        apiProvider: any APIProvider,
        converter: any TransactionListConverter,
        errorConverter: any DomainErrorConverter
    ) {
        self.apiProvider = apiProvider
        self.converter = converter
        self.errorConverter = errorConverter
    }

    func download(id: String, page: Int) async {
        await state.send(value: .loading)

        let parameters: Parameters = [
            "page": page,
            "size": pageSize
        ]

        do {
            let result: TransactionListModel = try await apiProvider.request(
                endpoint: .accountTransactions(id: id),
                method: .get,
                parameters: parameters
            )
            let data = converter.convert(result)
            try Task.checkCancellation()
            await state.send(value: .data(data))
        } catch {
            guard !Task.isCancelled else { return }
            await state.send(value: .error(errorConverter.convert(error: error)))
        }
    }

    func observe() async -> any NetworkStatePipeline<TransactionListEntity> {
        state
    }
}
