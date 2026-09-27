import Foundation
import SharedExtensions
import Testing

@Suite("DateTextFormatter")
struct DateTextFormatterTests {
    private static let date = Date(timeIntervalSince1970: 1_371_592_800)

    @Test("date only uses the date locale and time zone")
    func test_givenDate_whenFormatDateOnly_thenLocalDate() {
        // arrange
        let sut = makeSUT(timeZone: TimeZone(identifier: "Europe/Prague"))

        // act
        let result = sut.format(Self.date, format: .dateOnly)

        // assert
        #expect(result == "6/19/2013")
    }

    @Test("date and time contain both parts")
    func test_givenDate_whenFormatDateTime_thenDateAndTime() {
        // arrange
        let sut = makeSUT(timeZone: .gmt)

        // act
        let result = sut.format(Self.date, format: .dateTime)

        // assert
        #expect(result.contains("6/18/2013"))
        #expect(result.contains("10:00"))
    }

    @Test("month and year use the month locale")
    func test_givenDate_whenFormatMonthAndYear_thenMonthName() {
        // arrange
        let sut = makeSUT(timeZone: .gmt)

        // act
        let result = sut.format(Self.date, format: .monthAndYear)

        // assert
        #expect(result == "June 2013")
    }

    private func makeSUT(timeZone: TimeZone?) -> DateTextFormatterImp {
        DateTextFormatterImp(
            locale: Locale(identifier: "en_US"),
            monthLocale: Locale(identifier: "en_US"),
            timeZone: timeZone ?? .gmt
        )
    }
}
