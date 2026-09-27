import DIContainer
import Networking
import Service
import UIKit
import UIKitNavigation
import Models
import SharedExtensions

public final class AccountContainer: BaseContainer {
    let networkingContainer: NetworkingContainer
    let modelsContainer: ModelsContainer
    let appErrorContainer: AppErrorContainer
    let formatterContainer: FormatterContainer
    let serviceContainer: ServiceContainer

    public init(
        networkingContainer: NetworkingContainer,
        modelsContainer: ModelsContainer,
        appErrorContainer: AppErrorContainer,
        formatterContainer: FormatterContainer,
        serviceContainer: ServiceContainer
    ) {
        self.networkingContainer = networkingContainer
        self.modelsContainer = modelsContainer
        self.appErrorContainer = appErrorContainer
        self.formatterContainer = formatterContainer
        self.serviceContainer = serviceContainer
    }

    public func makeCoordinator(navigationController: UINavigationController) -> any Coordinator {
        AccountCoordinator(navigationController: navigationController, container: self)
    }
}
