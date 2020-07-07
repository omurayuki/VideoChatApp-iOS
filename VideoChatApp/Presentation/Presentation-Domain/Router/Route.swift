import UIKit

enum Route {
    
    case entrance
    
    func viewController() -> UIViewController {
        
        let viewController: UIViewController
        
        switch self {
        case .entrance:
            viewController = Resources.ViewControllers.App.Login()
        
        return viewController
    }
}
