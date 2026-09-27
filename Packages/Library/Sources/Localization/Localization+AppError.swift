public extension Localization {
    enum AppError {
        public static var offlineTitle: String { tr("app_error.offline.title", fallback: "You're offline") }
        public static var offlineMessage: String { tr("app_error.offline.message", fallback: "Check your connection and try again.") }
        public static var notFoundTitle: String { tr("app_error.not_found.title", fallback: "Not found") }
        public static var notFoundMessage: String { tr("app_error.not_found.message", fallback: "This account is no longer published.") }
        public static var genericTitle: String { tr("app_error.generic.title", fallback: "Something went wrong") }
        public static var serverMessage: String {
            tr("app_error.server.message", fallback: "The bank's server didn't respond as expected. Please try again.")
        }
        public static var genericMessage: String { tr("app_error.generic.message", fallback: "Please try again.") }
    }
}
