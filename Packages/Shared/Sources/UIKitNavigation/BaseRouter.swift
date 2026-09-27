@MainActor
public protocol BaseRouter: AnyObject, Sendable {
    func close()
    func goBack()
}
