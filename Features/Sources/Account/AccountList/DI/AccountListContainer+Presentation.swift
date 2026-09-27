import Localization
import SwiftUI
import UIComponents

extension AccountContainer {
    func makeAccountListViewController(router: any AccountListRouter) -> UIViewController {
        let viewModel = makeAccountListViewModel(router: router)
        return SearchableHostingController(
            rootView: AccountListView(viewModel: viewModel),
            searchPrompt: Localization.AccountList.searchPrompt,
            onSearch: { [weak viewModel] text in viewModel?.onSearch(text) }
        )
    }

    private func makeAccountListViewModel(router: any AccountListRouter) -> AccountListViewModel {
        AccountListViewModel(
            router: router,
            getAccounts: makeAccountListUseCase(),
            debounce: serviceContainer.makeAsyncDebounceUseCase(),
            contentConverter: makeAccountListContentConverter(),
            errorConverter: appErrorContainer.makeErrorViewModelConverter()
        )
    }

    private func makeAccountListContentConverter() -> AccountListContentConverter {
        AccountListContentConverterImp(
            amountFormatter: formatterContainer.makeAmountFormatter(),
            accountNumberFormatter: formatterContainer.makeAccountNumberFormatter()
        )
    }
}
