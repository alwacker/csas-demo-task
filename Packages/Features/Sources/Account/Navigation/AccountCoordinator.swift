import UIKit
import UIKitNavigation

@MainActor
final class AccountCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    private let container: AccountContainer

    init(navigationController: UINavigationController, container: AccountContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let accountList = container.makeAccountListViewController(router: self)
        navigationController.setViewControllers([accountList], animated: false)
    }
}

extension AccountCoordinator: AccountListRouter {
    func accountSelected(id: String) {
        let accountDetail = container.makeAccountDetailViewController(id: id)
        navigationController.pushViewController(accountDetail, animated: true)
    }
}
