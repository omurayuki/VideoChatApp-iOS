import SkyWay

enum SkyWayClientErrorType {
    
    case call
    case dataConnect
    case listFetching
}

final class SkyWayErrorHandler: ErrorHandler {
    
    func synthesizeApiError<T>(_ error: T?, handler: (String) -> Void) {
        guard let error = error as? SKWPeerError else {
            Logger.error("can't resolve SKWPeerError.")
            return
        }
        
        switch error.type {
        case .PEER_ERR_NETWORK:
            handler("PEER_ERR_NETWORK")
            
        case .PEER_ERR_DISCONNECTED,
             .PEER_ERR_PEER_UNAVAILABLE,
             .PEER_ERR_SERVER_ERROR,
             .PEER_ERR_SOCKET_CLOSED,
             .PEER_ERR_SOCKET_ERROR:
            handler("PEER_ERR_DISCONNECTED")
            
        default:
            handler("default")
        }
    }
    
    func synthesizeClientError(type error: SkyWayClientErrorType, handler: (String) -> Void) {
        switch error {
        case .call:
            handler("call")
            
        case .dataConnect:
            handler("dataConnect")
            
        case .listFetching:
            handler("listFetching")
        }
    }
}
