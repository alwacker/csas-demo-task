import Models
import UIComponents

final class AccountDetailViewModel: LoadingViewModel<AccountDetailViewModel.Content> {
    struct Content: Equatable, Sendable {
        let header: AccountDetailHeader
        let sections: [InfoSection]
        let transactions: [TransactionGroup]
        let hasMoreTransactions: Bool
    }

    private let id: String
    private let getAccount: any AccountDetailUseCase
    private let getTransactions: any TransactionListUseCase
    private let contentConverter: any AccountDetailContentConverter
    private let errorConverter: any ErrorViewModelConverter

    private var account: AccountDetailEntity?
    private var nextPage: Int?
    private var loadTask: Task<Void, Never>?

    init(
        id: String,
        getAccount: any AccountDetailUseCase,
        getTransactions: any TransactionListUseCase,
        contentConverter: any AccountDetailContentConverter,
        errorConverter: any ErrorViewModelConverter
    ) {
        self.id = id
        self.getAccount = getAccount
        self.getTransactions = getTransactions
        self.contentConverter = contentConverter
        self.errorConverter = errorConverter
        super.init()
    }

    func onLoad() async {
        await load(page: .zero)
    }

    func onRetry() async {
        setLoading()
        await load(page: .zero)
    }

    func onReachedEnd() async {
        guard let page = nextPage, page > .zero else { return }
        nextPage = nil
        await load(page: page)
    }

    private func load(page: Int) async {
        loadTask?.cancel()
        let task = Task { await performLoad(page: page) }
        loadTask = task
        await task.value
    }

    private func performLoad(page: Int) async {
        do {
            let account: AccountDetailEntity
            let transactions: TransactionListEntity

            if page == .zero {
                async let accountRequest = getAccount(id: id)
                async let transactionsRequest = getTransactions(id: id, page: page)
                (account, transactions) = try await (accountRequest, transactionsRequest)
            } else if let loadedAccount = self.account {
                account = loadedAccount
                transactions = try await getTransactions(id: id, page: page)
            } else {
                return
            }

            self.account = account
            nextPage = transactions.nextPage
            setContent(contentConverter.convert(
                account: account,
                transactions: transactions,
                previous: page == .zero ? nil : state.contentModel
            ))
        } catch {
            guard !Task.isCancelled else { return }
            setError(errorConverter.convert(error: error))
        }
    }
}
