import UIKitNavigation

@MainActor
protocol AccountListRouter: BaseRouter {
    func accountSelected(id: String)
}
