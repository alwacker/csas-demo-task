import SwiftUI

extension AccountContainer {
    func makeAccountDetailViewController(id: String) -> UIViewController {
        UIHostingController(rootView: AccountDetailView(viewModel: self.makeAccountDetailViewModel(id: id)))
    }

    private func makeAccountDetailViewModel(id: String) -> AccountDetailViewModel {
        AccountDetailViewModel(
            id: id,
            getAccount: makeAccountDetailUseCase(),
            getTransactions: makeTransactionListUseCase(),
            contentConverter: makeAccountDetailContentConverter(),
            errorConverter: appErrorContainer.makeErrorViewModelConverter()
        )
    }

    private func makeAccountDetailContentConverter() -> AccountDetailContentConverter {
        AccountDetailContentConverterImp(
            amountFormatter: formatterContainer.makeAmountFormatter(),
            accountNumberFormatter: formatterContainer.makeAccountNumberFormatter(),
            dateFormatter: formatterContainer.makeDateTextFormatter()
        )
    }
}
