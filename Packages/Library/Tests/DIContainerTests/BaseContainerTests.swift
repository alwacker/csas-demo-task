import Testing
@testable import DIContainer

@MainActor
@Suite("BaseContainer")
struct BaseContainerTests {
    private final class Dependency {}

    private final class TestContainer: BaseContainer {
        func makeSingletonDependency() -> Dependency {
            makeSingleton { Dependency() }
        }

        func makeSharedDependency() -> Dependency {
            makeShared { Dependency() }
        }
    }

    @Test("a singleton is built once and reused")
    func test_givenSingleton_whenMadeTwice_thenSameInstance() {
        // arrange
        let sut = TestContainer()

        // act
        let first = sut.makeSingletonDependency()
        let second = sut.makeSingletonDependency()

        // assert
        #expect(first === second)
    }

    @Test("a shared instance is reused while someone holds it")
    func test_givenSharedHeld_whenMadeAgain_thenSameInstance() {
        // arrange
        let sut = TestContainer()
        let held = sut.makeSharedDependency()

        // act
        let again = sut.makeSharedDependency()

        // assert
        #expect(held === again)
    }

    @Test("a shared instance is rebuilt after the last holder released it")
    func test_givenSharedReleased_whenMadeAgain_thenNewInstance() {
        // arrange
        let sut = TestContainer()
        weak let released = sut.makeSharedDependency()

        // act
        let fresh = sut.makeSharedDependency()

        // assert
        #expect(released == nil)
        #expect(fresh !== released)
    }
}
