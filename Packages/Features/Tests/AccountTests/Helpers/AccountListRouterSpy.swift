@testable import Account

@MainActor
final class AccountListRouterSpy: AccountListRouter {
    private(set) var selectedIDs: [String] = []

    func accountSelected(id: String) {
        selectedIDs.append(id)
    }

    func close() {}
    func goBack() {}
}
