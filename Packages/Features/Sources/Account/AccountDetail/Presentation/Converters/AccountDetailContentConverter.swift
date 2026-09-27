import Foundation
import Localization
import SharedExtensions
import UIComponents

protocol AccountDetailContentConverter: Sendable {
    func convert(
        account: AccountDetailEntity,
        transactions: TransactionListEntity,
        previous: AccountDetailViewModel.Content?
    ) -> AccountDetailViewModel.Content
}

struct AccountDetailContentConverterImp: AccountDetailContentConverter {
    private let amountFormatter: any AmountFormatter
    private let accountNumberFormatter: any AccountNumberFormatter
    private let dateFormatter: any DateTextFormatter

    init(
        amountFormatter: any AmountFormatter,
        accountNumberFormatter: any AccountNumberFormatter,
        dateFormatter: any DateTextFormatter
    ) {
        self.amountFormatter = amountFormatter
        self.accountNumberFormatter = accountNumberFormatter
        self.dateFormatter = dateFormatter
    }

    func convert(
        account: AccountDetailEntity,
        transactions: TransactionListEntity,
        previous: AccountDetailViewModel.Content?
    ) -> AccountDetailViewModel.Content {
        AccountDetailViewModel.Content(
            header: makeHeader(account),
            sections: [
                makeAccountSection(account),
                makeAboutSection(account),
                makeTransparencySection(account)
            ].compactMap { $0 },
            transactions: makeGroups(transactions.transactions, previous: previous?.transactions ?? []),
            hasMoreTransactions: transactions.nextPage != nil
        )
    }

    private func makeHeader(_ account: AccountDetailEntity) -> AccountDetailHeader {
        AccountDetailHeader(
            name: account.name.trimmingCharacters(in: .whitespacesAndNewlines),
            status: account.transparencyTo > .now ? .active : .closed,
            balance: amountFormatter.format(account.amount.value, currencyCode: account.amount.currency.code)
        )
    }

    private func makeAccountSection(_ account: AccountDetailEntity) -> InfoSection {
        InfoSection(
            title: Localization.AccountDetail.accountSection,
            rows: [
                InfoRow(
                    label: Localization.AccountDetail.accountNumber,
                    value: accountNumberFormatter.format(accountNumber: account.accountNumber, bankCode: account.bankCode),
                    isCopyable: true
                ),
                InfoRow(label: Localization.AccountDetail.iban, value: account.iban, isCopyable: true)
            ]
        )
    }

    private func makeAboutSection(_ account: AccountDetailEntity) -> InfoSection? {
        let rows = [
            account.description.map { InfoRow(label: Localization.AccountDetail.purpose, value: $0) },
            account.note.map { InfoRow(label: Localization.AccountDetail.note, value: $0) }
        ].compactMap { $0 }

        guard !rows.isEmpty else { return nil }
        return InfoSection(title: Localization.AccountDetail.aboutSection, rows: rows)
    }

    private func makeTransparencySection(_ account: AccountDetailEntity) -> InfoSection {
        InfoSection(
            title: Localization.AccountDetail.transparencySection,
            rows: [
                InfoRow(
                    label: Localization.AccountDetail.transparentSince,
                    value: dateFormatter.format(account.transparencyFrom, format: .dateOnly)
                ),
                InfoRow(
                    label: Localization.AccountDetail.transparentUntil,
                    value: dateFormatter.format(account.transparencyTo, format: .dateOnly)
                ),
                InfoRow(
                    label: Localization.AccountDetail.publishedUntil,
                    value: dateFormatter.format(account.publicationTo, format: .dateOnly)
                ),
                InfoRow(
                    label: Localization.AccountDetail.lastUpdated,
                    value: dateFormatter.format(account.actualizationDate, format: .dateTime)
                )
            ]
        )
    }

    private func makeGroups(_ transactions: [TransactionEntity], previous: [TransactionGroup]) -> [TransactionGroup] {
        let offset = previous.reduce(0) { $0 + $1.rows.count }

        return transactions.enumerated().reduce(into: previous) { groups, item in
            let month = dateFormatter.format(item.element.processingDate, format: .monthAndYear)
            let row = makeRow(item.element, id: offset + item.offset)

            if let last = groups.last, last.title == month {
                groups[groups.count - 1] = TransactionGroup(title: month, rows: last.rows + [row])
            } else {
                groups.append(TransactionGroup(title: month, rows: [row]))
            }
        }
    }

    private func makeRow(_ transaction: TransactionEntity, id: Int) -> TransactionRow {
        let type = transaction.typeDescription?.trimmingCharacters(in: .whitespaces)
        let value = transaction.amount.value

        return TransactionRow(
            id: id,
            title: transaction.counterpartyName ?? type ?? Localization.AccountDetail.transaction,
            message: transaction.message,
            date: dateFormatter.format(transaction.processingDate, format: .dateOnly),
            category: transaction.counterpartyName == nil ? nil : type,
            amount: amountFormatter.format(value, currencyCode: transaction.amount.currency.code).text,
            direction: value < 0 ? .outgoing : .incoming
        )
    }
}
