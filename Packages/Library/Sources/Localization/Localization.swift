import Foundation

public enum Localization {
    static func tr(_ key: String, fallback: String) -> String {
        Bundle.module.localizedString(forKey: key, value: fallback, table: nil)
    }

    static func tr(_ key: String, fallback: String, _ arguments: CVarArg...) -> String {
        String(format: tr(key, fallback: fallback), locale: .current, arguments: arguments)
    }
}
