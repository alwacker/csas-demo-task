import UIKit
import UIKitNavigation

@MainActor
final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let container: AppContainer
    private let navigationController = UINavigationController()
    private var childCoordinators: [any Coordinator] = []

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        configureNavigationBar()

        let account = container
            .makeAccountContainer()
            .makeCoordinator(navigationController: navigationController)
        
        childCoordinators.append(account)
        account.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func configureNavigationBar() {
        navigationController.navigationBar.prefersLargeTitles = true
    }
}
