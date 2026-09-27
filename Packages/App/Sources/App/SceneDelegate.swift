import UIKit

public final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    public func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(window: window, container: AppContainer())
        self.window = window
        appCoordinator = coordinator
        coordinator.start()
    }
}
