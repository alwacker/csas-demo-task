import Foundation
import Models
import Service
import SharedExtensions
import UIComponents

final class AccountListViewModel: LoadingViewModel<AccountListViewModel.Content> {
    struct Content: Equatable, Sendable {
        enum Body: Equatable, Sendable {
            case accounts([Row], hasMore: Bool)
            case noResults(query: String)
        }

        struct Row: Equatable, Sendable, Identifiable {
            let id: String
            let name: String
            let status: AccountStatus
            let accountNumber: String
            let balance: FormattedAmount
            let purpose: String?
        }

        let body: Body
        let subtitle: String
    }

    private weak var router: (any AccountListRouter)?
    private let getAccounts: any AccountListUseCase
    private let debounce: any AsyncDebounceUseCase
    private let debounceInterval: Duration
    private let contentConverter: any AccountListContentConverter
    private let errorConverter: any ErrorViewModelConverter

    private var nextPage: Int? = .zero
    private var query = ""
    private var loadTask: Task<Void, Never>?

    init(
        router: any AccountListRouter,
        getAccounts: any AccountListUseCase,
        debounce: any AsyncDebounceUseCase,
        contentConverter: any AccountListContentConverter,
        errorConverter: any ErrorViewModelConverter,
        debounceInterval: Duration = .milliseconds(300)
    ) {
        self.router = router
        self.getAccounts = getAccounts
        self.debounce = debounce
        self.debounceInterval = debounceInterval
        self.contentConverter = contentConverter
        self.errorConverter = errorConverter
        super.init()
    }

    func onLoad() async {
        setLoading()
        await load(page: .zero)
    }

    func onRetry() async {
        setLoading()
        await load(page: .zero)
    }

    func onRefresh() async {
        await load(page: .zero)
    }

    func onSearch(_ text: String) {
        guard text != query else { return }
        query = text
        debounce(interval: debounceInterval) { [weak self] in
            await self?.search()
        }
    }

    func onReachedEnd() async {
        guard let page = nextPage, page > .zero else { return }
        nextPage = nil
        await load(page: page)
    }

    func onAccountTap(id: String) {
        router?.accountSelected(id: id)
    }

    private func search() async {
        setLoading()
        await load(page: .zero)
    }

    private func load(page: Int) async {
        loadTask?.cancel()
        let task = Task { await performLoad(page: page) }
        loadTask = task
        await task.value
    }

    private func performLoad(page: Int) async {
        let previous = page == .zero ? nil : state.contentModel
        do {
            let entity = try await getAccounts(page: page, query: query)
            nextPage = entity.nextPage
            setContent(contentConverter.convert(entity, previous: previous, query: query))
        } catch {
            guard !Task.isCancelled else { return }
            setError(errorConverter.convert(error: error))
        }
    }
}
