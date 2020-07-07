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
            
            func videoChat() -> VideoChatViewController {
                let vc = VideoChatViewController.instantiate()
                vc.routing = VideoChatRouting()
                return vc
            }
        }
    }
}
