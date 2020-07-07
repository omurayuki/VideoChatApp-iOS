import Foundation
//import Firebase

final class AppConfigurator {
    
    // MARK: Configure App Sensitive Data
    
    private static var config: [AnyHashable: Any]? = {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: path ?? String.blank) as? [AnyHashable: Any]
        
        return plist?["AppConfig"] as? [AnyHashable: Any]
    }()
    
    static var currentSkyWayAPIKey: String {
        guard
            let apiKey = config?["SkyWayAPIKey"] as? String
        else {
            Logger.error("Wrong API Key!!")
            return ""
        }
        Logger.debug("SkyWay API key for debugging: \(apiKey)")
        
        return apiKey
    }
    
    static var currentSkyWayDomain: String {
        guard
            let domain = config?["SkyWayDomain"] as? String
        else {
            Logger.error("Wrong Domain!!")
            return ""
        }
        Logger.debug("SkyWay Domain for debugging: \(domain)")
        
        return domain
    }
    
    // MARK: Configure Firebase
    /**
     if use firebase component
     */
    
    private static var currentFirebaseFilePath: String {
        let filePath: String?
        #if DEBUG
            filePath = Bundle.main.path(forResource: "GoogleService-debug-Info", ofType: "plist")
        #else
            filePath = Bundle.main.path(forResource: "GoogleService-release-Info", ofType: "plist")
        #endif
        
        return filePath ?? String.blank
    }
    
    static func setupFirebase() {
//        let optsPath = currentFirebaseFilePath
//        guard !optsPath.isEmpty, let fileopts = FirebaseOptions(contentsOfFile: optsPath) else {
//            Logger.debug("Invalid Firebase configuration file. FILE: \(optsPath)")
//            return
//        }
//        FirebaseConfiguration.shared.setLoggerLevel(.min)
//        FirebaseApp.configure(options: fileopts)
    }
}
