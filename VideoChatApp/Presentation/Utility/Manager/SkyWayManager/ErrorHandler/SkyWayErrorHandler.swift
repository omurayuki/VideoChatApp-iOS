import SkyWay

enum SkyWayClientErrorType {
    
    case call
    case dataConnect
    case connectPeer
    case listFetching
}

final class SkyWayErrorHandler: ErrorHandler {
    
    func synthesizeApiError<T>(_ error: T?,
                               handler: (String) -> Void) {
        guard let error = error as? SKWPeerError else {
            Logger.error("can't resolve SKWPeerError.")
            return
        }
        
        switch error.type {
        case .PEER_ERR_NETWORK:
            handler(Resources.Strings.Error.errorMessageNetworkRetryCall)
            
        case .PEER_ERR_DISCONNECTED,
             .PEER_ERR_PEER_UNAVAILABLE,
             .PEER_ERR_SERVER_ERROR,
             .PEER_ERR_SOCKET_CLOSED,
             .PEER_ERR_SOCKET_ERROR:
            handler(Resources.Strings.Error.errorMessageNetworkCutting)
            
        default:
            handler(Resources.Strings.Error.errorMessageUnknown)
        }
    }
    
    func synthesizeClientError(type error: SkyWayClientErrorType,
                               handler: (String) -> Void) {
        switch error {
        case .call:
            handler(Resources.Strings.Error.errorMessageFailedCalling)
            
        case .dataConnect:
            handler(Resources.Strings.Error.errorMessageFetchUniqueData)
            
        case .connectPeer:
            handler(Resources.Strings.Error.errorMessageConnect)
            
        case .listFetching:
            handler(Resources.Strings.Error.errorMessageFailedFetchingList)
        }
    }
}
