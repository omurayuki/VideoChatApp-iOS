import UIKit

extension Resources {
    
    static var ViewControllers: ViewController {
        ViewController()
    }
    
    struct ViewController {
        
        var App: AppControllers {
            AppControllers()
        }

        struct AppControllers {
            
//            func entrance() -> LoginViewController {
//                let vc = LoginViewController.instantiate()
//                vc.routing = LoginRouting()
//                return vc
//            }
        }
    }
}
