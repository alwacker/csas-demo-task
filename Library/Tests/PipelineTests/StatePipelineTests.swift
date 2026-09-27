import Testing
@testable import Pipeline

@Suite("StatePipeline")
struct StatePipelineTests {
    private typealias SUT = StatePipeline<Int>

    @Test("getValue returns the initial value")
    func test_givenInitialValue_whenGetValue_thenReturnsInitialValue() async {
        // arrange
        let sut = SUT(value: 0)

        // act
        let value = await sut.getValue()

        // assert
        #expect(value == 0)
    }

    @Test("send replaces the current value")
    func test_givenPipeline_whenSend_thenGetValueReturnsNewValue() async {
        // arrange
        let sut = SUT(value: 0)

        // act
        await sut.send(value: 5)

        // assert
        #expect(await sut.getValue() == 5)
    }

    @Test("a subscriber gets the current value first, then every update in order")
    func test_givenSubscriber_whenSendValues_thenReceivesAllInOrder() async {
        // arrange
        let sut = SUT(value: 0)
        let stream = await sut.values()

        // act
        await sut.send(value: 1)
        await sut.send(value: 2)
        await sut.send(value: 3)

        // assert
        #expect(await collect(stream, count: 4) == [0, 1, 2, 3])
    }

    @Test("every subscriber gets its own copy of each value")
    func test_givenTwoSubscribers_whenSend_thenBothReceive() async {
        // arrange
        let sut = SUT(value: 0)
        let first = await sut.values()
        let second = await sut.values()

        // act
        await sut.send(value: 42)

        // assert
        #expect(await collect(first, count: 2) == [0, 42])
        #expect(await collect(second, count: 2) == [0, 42])
    }

    @Test("a late subscriber starts from the latest value, not from history")
    func test_givenSentValues_whenLateSubscribe_thenReceivesLatestValueFirst() async {
        // arrange
        let sut = SUT(value: 0)
        await sut.send(value: 1)
        await sut.send(value: 7)

        // act
        let stream = await sut.values()

        // assert
        #expect(await collect(stream, count: 1) == [7])
    }

    private func collect(_ stream: AsyncStream<Int>, count: Int) async -> [Int] {
        var result: [Int] = []
        for await value in stream {
            result.append(value)
            if result.count == count { break }
        }
        return result
    }
}
