import Foundation
import CoreLocation

final class Notifications {
    
    static func didUpdate<T: NSObject>(notification name: Notification.Name,
                                       userInfo: [Keys: T]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}

extension Notification.Name {
    
    enum Name: String {
        
        case updateSKWApiError
    }
    
    static let updateSKWApiError
        = Notification.Name(rawValue: Name.updateSKWApiError.rawValue)
}
