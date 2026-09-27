import Foundation
import Testing
@testable import Models

@Suite("ErrorViewModelConverter")
struct ErrorViewModelConverterTests {
    @Test("the API error code from the body is shown")
    func test_givenErrorBody_whenConvert_thenCodeFromBody() {
        // arrange
        let sut = ErrorViewModelConverterImp()
        let body = Data(#"{"status":412,"errors":[{"error":"KEY_NOT_FOUND"}]}"#.utf8)

        // act
        let result = sut.convert(error: DomainError.error(data: body))

        // assert
        #expect(result.code == "KEY_NOT_FOUND")
    }

    @Test("an unreadable body still yields an error screen, without a code")
    func test_givenGarbageBody_whenConvert_thenNoCode() {
        // arrange
        let sut = ErrorViewModelConverterImp()

        // act
        let result = sut.convert(error: DomainError.error(data: Data("<html>".utf8)))

        // assert
        #expect(result.code == nil)
    }
}
