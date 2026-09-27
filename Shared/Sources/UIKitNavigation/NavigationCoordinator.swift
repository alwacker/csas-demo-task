import UIKit

@MainActor
public protocol NavigationCoordinator: Coordinator, BaseRouter {
    var navigationController: UINavigationController { get }
}

public extension NavigationCoordinator {
    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func close() {
        navigationController.dismiss(animated: true)
    }
}
