import Foundation

public enum Environment {
    public static var baseURL: String? {
        Bundle.main.infoDictionary?["BASE_URL"] as? String
    }

    public static var apiKey: String? {
        Bundle.main.infoDictionary?["API_KEY"] as? String
    }
}
