import Models
import Networking
import Pipeline

actor AccountListRepositoryImp: AccountListRepository {
    private let pageSize = 50
    private let apiProvider: any APIProvider
    private let converter: any AccountListConverter
    private let errorConverter: any DomainErrorConverter
    private let state = StatePipeline<NetworkRepositoryState<AccountListEntity>>(value: .loading)

    init(
        apiProvider: any APIProvider,
        converter: any AccountListConverter,
        errorConverter: any DomainErrorConverter
    ) {
        self.apiProvider = apiProvider
        self.converter = converter
        self.errorConverter = errorConverter
    }

    func download(page: Int, filter: String?) async {
        await state.send(value: .loading)

        var parameters: Parameters = [
            "page": page,
            "size": pageSize
        ]
        
        if let filter, !filter.isEmpty {
            parameters["filter"] = filter
        }

        do {
            let result: AccountListModel = try await apiProvider.request(
                endpoint: .accountList,
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

    func observe() async -> any NetworkStatePipeline<AccountListEntity> {
        state
    }
}
