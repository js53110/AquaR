import Foundation

enum UserDefaultsService {
    
    static func saveDataToUserDefaults(id: String?) {
        UserDefaults.standard.set(id, forKey: "consumerToken")
    }
    
    static func retrieveDataFromUserDefaults() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "consumerToken") else {
            return nil // Default value if token doesn't exist
        }
        return token
    }
}
