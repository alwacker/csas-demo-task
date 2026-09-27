public extension Localization {
    enum AccountDetail {
        public static var sectionPicker: String { tr("account_detail.section_picker", fallback: "Section") }
        public static var transactionsTab: String { tr("account_detail.transactions_tab", fallback: "Transactions") }
        public static var infoTab: String { tr("account_detail.info_tab", fallback: "Info") }
        public static var loading: String { tr("account_detail.loading", fallback: "Loading account") }
        public static var noTransactions: String { tr("account_detail.no_transactions", fallback: "No transactions") }
        public static var transaction: String { tr("account_detail.transaction", fallback: "Transaction") }
        public static var accountSection: String { tr("account_detail.account_section", fallback: "Account") }
        public static var accountNumber: String { tr("account_detail.account_number", fallback: "Account number") }
        public static var iban: String { tr("account_detail.iban", fallback: "IBAN") }
        public static var aboutSection: String { tr("account_detail.about_section", fallback: "About") }
        public static var purpose: String { tr("account_detail.purpose", fallback: "Purpose") }
        public static var note: String { tr("account_detail.note", fallback: "Note") }
        public static var transparencySection: String { tr("account_detail.transparency_section", fallback: "Transparency") }
        public static var transparentSince: String { tr("account_detail.transparent_since", fallback: "Transparent since") }
        public static var transparentUntil: String { tr("account_detail.transparent_until", fallback: "Transparent until") }
        public static var publishedUntil: String { tr("account_detail.published_until", fallback: "Published until") }
        public static var lastUpdated: String { tr("account_detail.last_updated", fallback: "Last updated") }
    }
}
