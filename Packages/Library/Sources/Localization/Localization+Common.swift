public extension Localization {
    enum Common {
        public static var active: String { tr("common.active", fallback: "Active") }
        public static var closed: String { tr("common.closed", fallback: "Closed") }
        public static var copied: String { tr("common.copied", fallback: "Copied") }
        public static var copyAccountNumber: String { tr("common.copy_account_number", fallback: "Copy account number") }
        public static var tryAgain: String { tr("common.try_again", fallback: "Try again") }
        public static var loadingTransactions: String { tr("common.loading_transactions", fallback: "Loading transactions") }

        public static func copy(_ label: String) -> String {
            tr("common.copy", fallback: "Copy %@", label)
        }
    }
}
