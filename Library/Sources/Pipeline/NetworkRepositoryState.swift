import Models

public enum NetworkRepositoryState<Data: Sendable>: Sendable {
    case loading
    case data(Data)
    case error(DomainError)
}

extension NetworkRepositoryState: Equatable where Data: Equatable {}

public extension NetworkRepositoryState {
    func getData() throws(DomainError) -> Data {
        switch self {
        case let .data(result):
            return result
        case let .error(error):
            throw error
        case .loading:
            throw .unknown
        }
    }
}

public typealias NetworkStatePipeline<Value: Sendable> = Pipeline<NetworkRepositoryState<Value>>
