import Foundation

extension Date {
    static func gmt(_ year: Int, _ month: Int, _ day: Int) -> Date {
        DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .gmt,
            year: year,
            month: month,
            day: day
        ).date ?? .distantPast
    }
}
