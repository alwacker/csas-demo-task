import SharedExtensions
import UIComponents

struct AccountDetailHeader: Equatable, Sendable {
    let name: String
    let status: AccountStatus
    let balance: FormattedAmount
}
