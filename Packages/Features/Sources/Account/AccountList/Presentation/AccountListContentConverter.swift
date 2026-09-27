import Foundation
import Localization
import SharedExtensions
import UIComponents

protocol AccountListContentConverter: Sendable {
    func convert(
        _ entity: AccountListEntity,
        previous: AccountListViewModel.Content?,
        query: String
    ) -> AccountListViewModel.Content
}

struct AccountListContentConverterImp: AccountListContentConverter {
    private let amountFormatter: any AmountFormatter
    private let accountNumberFormatter: any AccountNumberFormatter

    init(
        amountFormatter: any AmountFormatter,
        accountNumberFormatter: any AccountNumberFormatter
    ) {
        self.amountFormatter = amountFormatter
        self.accountNumberFormatter = accountNumberFormatter
    }

    func convert(
        _ entity: AccountListEntity,
        previous: AccountListViewModel.Content?,
        query: String
    ) -> AccountListViewModel.Content {
        let rows = previousRows(previous) + entity.accounts.map(makeRow)
        let subtitle = Localization.AccountList.subtitle(count: entity.recordCount)

        guard !rows.isEmpty || query.isEmpty else {
            return AccountListViewModel.Content(body: .noResults(query: query), subtitle: subtitle)
        }
        return AccountListViewModel.Content(
            body: .accounts(rows, hasMore: entity.nextPage != nil),
            subtitle: subtitle
        )
    }

    private func previousRows(_ content: AccountListViewModel.Content?) -> [AccountListViewModel.Content.Row] {
        guard case let .accounts(rows, _) = content?.body else { return [] }
        return rows
    }

    private func makeRow(_ account: AccountEntity) -> AccountListViewModel.Content.Row {
        AccountListViewModel.Content.Row(
            id: account.accountNumber,
            name: account.name.trimmingCharacters(in: .whitespacesAndNewlines),
            status: account.transparencyTo > .now ? .active : .closed,
            accountNumber: accountNumberFormatter.format(accountNumber: account.accountNumber, bankCode: account.bankCode),
            balance: amountFormatter.format(account.amount.value, currencyCode: account.amount.currency.code),
            purpose: account.description
        )
    }
}
