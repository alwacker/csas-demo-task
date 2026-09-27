import Localization
import SwiftUI
import UIComponents

struct AccountListView: View {
    @StateObject var viewModel: AccountListViewModel

    var body: some View {
        ViewModelStateView(
            state: viewModel.state,
            onRetry: { await viewModel.onRetry() },
            loadingView: { makeSkeleton() },
            contentView: { content in makeContent(content) }
        )
        .brandBackground()
        .navigationTitle(Localization.AccountList.title)
        .navigationSubtitle(viewModel.state.contentModel?.subtitle ?? "")
        .navigationBarTitleDisplayMode(.large)
        .onLoadAsync { await viewModel.onLoad() }
    }

    @ViewBuilder
    private func makeContent(_ content: AccountListViewModel.Content) -> some View {
        switch content.body {
        case let .accounts(rows, hasMore):
            makeList(rows, hasMore: hasMore)
        case let .noResults(query):
            ContentUnavailableView.search(text: query)
        }
    }

    private func makeList(_ rows: [AccountListViewModel.Content.Row], hasMore: Bool) -> some View {
        ScrollView {
            LazyVStack(spacing: .cardGap) {
                ForEach(rows) { row in
                    AccountCardView(
                        name: row.name,
                        status: row.status,
                        balance: row.balance,
                        purpose: row.purpose,
                        accountNumber: row.accountNumber
                    )
                    .contentShape(.rect)
                    .onTapGesture { viewModel.onAccountTap(id: row.id) }
                    .accessibilityAddTraits(.isButton)
                }

                if hasMore {
                    ProgressView()
                        .padding(.vertical, .cardGap)
                        .task(id: rows.count) { await viewModel.onReachedEnd() }
                }
            }
            .padding(.horizontal, .screenMargin)
            .padding(.vertical, .cardGap)
        }
        .refreshable { await viewModel.onRefresh() }
    }

    private func makeSkeleton() -> some View {
        ScrollView {
            VStack(spacing: .cardGap) {
                ForEach(0 ..< 4, id: \.self) { _ in
                    AccountCardSkeletonView()
                }
            }
            .padding(.horizontal, .screenMargin)
            .padding(.vertical, .cardGap)
        }
        .scrollDisabled(true)
        .accessibilityElement()
        .accessibilityLabel(Localization.AccountList.loading)
    }
}
