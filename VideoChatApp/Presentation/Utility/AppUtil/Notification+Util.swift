import Foundation
import CoreLocation

final class Notifications {
    
    static func didUpdate<T: NSObject>(notification name: Notification.Name,
                                       userInfo: [String: T]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}

extension Notification.Name {
    
    enum Name: String {
        
        case updateSKWApiError
        case updateSKWClientError
        case callError
        case dataConnectError
        case connectPeerError
        case listFetchingError
    }
    
    static let updateSKWApiError
        = Notification.Name(rawValue: Name.updateSKWApiError.rawValue)
    static let updateSKWClientError
        = Notification.Name(rawValue: Name.updateSKWClientError.rawValue)
    static let callError
        = Notification.Name(rawValue: Name.callError.rawValue)
    static let dataConnectError
        = Notification.Name(rawValue: Name.dataConnectError.rawValue)
    static let connectPeerError
        = Notification.Name(rawValue: Name.connectPeerError.rawValue)
    static let listFetchingError
        = Notification.Name(rawValue: Name.listFetchingError.rawValue)
}
