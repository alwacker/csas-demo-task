import Account
import DIContainer
import Networking
import Models
import Service
import SharedExtensions

final class AppContainer: BaseContainer {
    func makeNetworkingContainer() -> NetworkingContainer {
        makeSingleton {
            NetworkingContainer()
        }
    }

    func makeModelsContainer() -> ModelsContainer {
        makeSingleton {
            ModelsContainer()
        }
    }

    func makeAppErrorContainer() -> AppErrorContainer {
        makeSingleton {
            AppErrorContainer()
        }
    }

    func makeFormatterContainer() -> FormatterContainer {
        makeSingleton {
            FormatterContainer()
        }
    }

    func makeServiceContainer() -> ServiceContainer {
        makeSingleton {
            ServiceContainer()
        }
    }

    func makeAccountContainer() -> AccountContainer {
        makeSingleton {
            AccountContainer(
                networkingContainer: self.makeNetworkingContainer(),
                modelsContainer: self.makeModelsContainer(),
                appErrorContainer: self.makeAppErrorContainer(),
                formatterContainer: self.makeFormatterContainer(),
                serviceContainer: self.makeServiceContainer()
            )
        }
    }
}
