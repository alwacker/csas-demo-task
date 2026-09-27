import DIContainer

public final class NetworkingContainer: BaseContainer {
    public func makeAPIProvider() -> APIProvider {
        return APIProviderImp()
    }
}
