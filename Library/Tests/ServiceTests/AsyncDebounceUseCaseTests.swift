import Testing
@testable import Service

@MainActor
@Suite("AsyncDebounceUseCase")
struct AsyncDebounceUseCaseTests {
    private actor Recorder {
        private(set) var values: [String] = []

        func append(_ value: String) {
            values.append(value)
        }
    }

    @Test("only the last action within the interval runs")
    func test_givenTwoCallsWithinInterval_whenDebounce_thenOnlyLastRuns() async throws {
        // arrange
        let sut = AsyncDebounceUseCaseImp()
        let recorder = Recorder()

        // act
        sut(interval: .milliseconds(50)) { await recorder.append("first") }
        sut(interval: .milliseconds(50)) { await recorder.append("second") }
        try await Task.sleep(for: .milliseconds(300))

        // assert
        #expect(await recorder.values == ["second"])
    }
}
