import UIKit

enum Route {
    
    case videoChat
    
    func viewController() -> UIViewController {
        
        let viewController: UIViewController
        
        switch self {
        case .videoChat:
            viewController = Resources.ViewControllers.App.videoChat()
        }
        
        return viewController
    }
}
