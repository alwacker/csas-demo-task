import Foundation
import Localization

public protocol ErrorViewModelConverter: Sendable {
    func convert(error: any Error) -> ErrorViewModel
}

final class ErrorViewModelConverterImp: ErrorViewModelConverter {
    func convert(error: any Error) -> ErrorViewModel {
        switch error as? DomainError {
        case .offline:
            ErrorViewModel(
                title: Localization.AppError.offlineTitle,
                message: Localization.AppError.offlineMessage
            )
        case .notFound:
            ErrorViewModel(
                title: Localization.AppError.notFoundTitle,
                message: Localization.AppError.notFoundMessage
            )
        case let .error(data):
            ErrorViewModel(
                title: Localization.AppError.genericTitle,
                message: Localization.AppError.serverMessage,
                code: errorCode(from: data)
            )
        case .cancelled, .unknown, nil:
            ErrorViewModel(
                title: Localization.AppError.genericTitle,
                message: Localization.AppError.genericMessage
            )
        }
    }

    private func errorCode(from data: Data) -> String? {
        let model = try? JSONDecoder().decode(APIErrorModel.self, from: data)
        return model?.errors?.first?.error ?? model?.status.map { "HTTP \($0)" }
    }
}
