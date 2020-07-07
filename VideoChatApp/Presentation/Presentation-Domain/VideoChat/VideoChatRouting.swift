import UIKit

protocol VideoChatRoutingProtocol: Routing {
    
    func pop(vc: UIViewController)
}

final class VideoChatRouting: VideoChatRoutingProtocol {
    
    func pop(vc: UIViewController) {
        router.dismiss(vc, animated: true, completion: nil)
    }
}
