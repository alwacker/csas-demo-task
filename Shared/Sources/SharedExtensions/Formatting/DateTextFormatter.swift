import Foundation

public protocol DateTextFormatter: Sendable {
    func format(_ date: Date, format: DateTextFormat) -> String
}

public struct DateTextFormatterImp: DateTextFormatter {
    private let locale: Locale
    private let monthLocale: Locale
    private let timeZone: TimeZone

    public init(
        locale: Locale = Locale(identifier: "cs_CZ"),
        monthLocale: Locale = .autoupdatingCurrent,
        timeZone: TimeZone = TimeZone(identifier: "Europe/Prague") ?? .current
    ) {
        self.locale = locale
        self.monthLocale = monthLocale
        self.timeZone = timeZone
    }

    public func format(_ date: Date, format: DateTextFormat) -> String {
        switch format {
        case .dateOnly:
            date.formatted(Date.FormatStyle(date: .numeric, time: .omitted, locale: locale, timeZone: timeZone))
        case .dateTime:
            date.formatted(Date.FormatStyle(date: .numeric, time: .shortened, locale: locale, timeZone: timeZone))
        case .monthAndYear:
            date.formatted(Date.FormatStyle(locale: monthLocale, timeZone: timeZone).month(.wide).year())
        }
    }
}
