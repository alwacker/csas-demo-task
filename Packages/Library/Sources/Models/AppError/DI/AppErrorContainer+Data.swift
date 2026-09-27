public extension AppErrorContainer {
    func makeDomainErrorConverter() -> DomainErrorConverter {
        DomainErrorConverterImp()
    }
}
