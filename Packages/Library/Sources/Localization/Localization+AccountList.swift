public extension Localization {
    enum AccountList {
        public static var title: String { tr("account_list.title", fallback: "Accounts") }
        public static var searchPrompt: String { tr("account_list.search_prompt", fallback: "Account name or purpose") }
        public static var loading: String { tr("account_list.loading", fallback: "Loading accounts") }

        public static func subtitle(count: Int) -> String {
            tr("account_list.subtitle", fallback: "%lld accounts", count)
        }
    }
}
