import Testing
@testable import App

@MainActor
@Suite("AppContainer")
struct AppContainerTests {
    @Test("module containers are app-wide singletons")
    func test_givenContainer_whenMakeModulesTwice_thenSameInstances() {
        // arrange
        let sut = AppContainer()

        // act & assert
        #expect(sut.makeAccountContainer() === sut.makeAccountContainer())
        #expect(sut.makeNetworkingContainer() === sut.makeNetworkingContainer())
        #expect(sut.makeAppErrorContainer() === sut.makeAppErrorContainer())
        #expect(sut.makeFormatterContainer() === sut.makeFormatterContainer())
        #expect(sut.makeServiceContainer() === sut.makeServiceContainer())
    }
}
