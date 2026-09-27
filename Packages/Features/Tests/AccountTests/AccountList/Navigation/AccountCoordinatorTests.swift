import Models
import Networking
import Service
import SharedExtensions
import SwiftUI
import Testing
import UIKit
@testable import Account

@MainActor
@Suite("AccountCoordinator")
struct AccountCoordinatorTests {
    private let navigationController = UINavigationController()

    @Test("start shows the account list as the root")
    func test_givenCoordinator_whenStart_thenListIsRoot() {
        // arrange
        let sut = makeSUT()

        // act
        sut.start()

        // assert
        #expect(navigationController.viewControllers.count == 1)
    }

    @Test("a selected account pushes its detail")
    func test_givenStarted_whenAccountSelected_thenDetailPushed() {
        // arrange
        let sut = makeSUT()
        sut.start()

        // act
        sut.accountSelected(id: "000000-2906478309")

        // assert
        #expect(navigationController.viewControllers.count == 2)
        #expect(navigationController.topViewController is UIHostingController<AccountDetailView>)
    }

    private func makeSUT() -> AccountCoordinator {
        AccountCoordinator(
            navigationController: navigationController,
            container: AccountContainer(
                networkingContainer: NetworkingContainer(),
                modelsContainer: ModelsContainer(),
                appErrorContainer: AppErrorContainer(),
                formatterContainer: FormatterContainer(),
                serviceContainer: ServiceContainer()
            )
        )
    }
}
