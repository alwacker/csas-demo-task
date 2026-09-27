public extension AppErrorContainer {
    func makeErrorViewModelConverter() -> ErrorViewModelConverter {
        ErrorViewModelConverterImp()
    }
}
