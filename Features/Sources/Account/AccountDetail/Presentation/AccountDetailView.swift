import Localization
import SwiftUI
import UIComponents

struct AccountDetailView: View {
    private enum Tab {
        case transactions
        case info
    }

    @StateObject var viewModel: AccountDetailViewModel
    @State private var tab: Tab = .transactions

    var body: some View {
        ViewModelStateView(
            state: viewModel.state,
            onRetry: { await viewModel.onRetry() },
            loadingView: { makeSkeleton() },
            contentView: { content in makeContent(content) }
        )
        .brandBackground()
        .navigationBarTitleDisplayMode(.inline)
        .onLoadAsync { await viewModel.onLoad() }
    }

    private func makeContent(_ content: AccountDetailViewModel.Content) -> some View {
        VStack(spacing: .sectionGap) {
            VStack(spacing: .sectionGap) {
                AccountHeaderView(
                    name: content.header.name,
                    status: content.header.status,
                    balance: content.header.balance
                )

                makeTabPicker(selection: $tab)
            }
            .padding(.horizontal, .screenMargin)
            .padding(.top, .cardGap)

            ScrollView {
                VStack(spacing: .sectionGap) {
                    switch tab {
                    case .transactions:
                        makeTransactions(content)
                    case .info:
                        ForEach(content.sections) { section in
                            InfoSectionView(section: section)
                        }
                    }
                }
                .padding(.horizontal, .screenMargin)
                .padding(.bottom, .cardGap)
            }
        }
    }

    private func makeTabPicker(selection: Binding<Tab>) -> some View {
        Picker(Localization.AccountDetail.sectionPicker, selection: selection) {
            Text(Localization.AccountDetail.transactionsTab).tag(Tab.transactions)
            Text(Localization.AccountDetail.infoTab).tag(Tab.info)
        }
        .pickerStyle(.segmented)
    }

    private func makeSkeleton() -> some View {
        VStack(spacing: .sectionGap) {
            AccountHeaderSkeletonView()
            makeTabPicker(selection: .constant(.transactions))
                .disabled(true)
            TransactionGroupSkeletonView()
            Spacer(minLength: .zero)
        }
        .padding(.horizontal, .screenMargin)
        .padding(.top, .cardGap)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Localization.AccountDetail.loading)
    }

    @ViewBuilder
    private func makeTransactions(_ content: AccountDetailViewModel.Content) -> some View {
        if content.transactions.isEmpty {
            ContentUnavailableView(
                Localization.AccountDetail.noTransactions,
                systemImage: "list.bullet.rectangle"
            )
        } else {
            LazyVStack(spacing: .groupGap) {
                ForEach(content.transactions) { group in
                    TransactionGroupView(group: group)
                }

                if content.hasMoreTransactions {
                    ProgressView()
                        .padding(.vertical, .cardGap)
                        .task(id: content.transactions.last?.rows.last?.id) { await viewModel.onReachedEnd() }
                }
            }
        }
    }
}
