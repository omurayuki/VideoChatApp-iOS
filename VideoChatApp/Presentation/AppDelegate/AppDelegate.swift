import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var callManager = CallManager()
    var providerDelegate: CallProvider!
    
    private let router: Router = Router()
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureInit()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.initialWindow(.videoChat, type: .navigation)
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    
    private func configureInit() {
        AppConfigurator.setupFirebase()
        providerDelegate = CallProvider(callManager: callManager)
    }
    
    func displayIncomingCall(
        uuid: UUID,
        handle: String? = nil,
        hasVideo: Bool = false,
        completion: ((Error?) -> Void)?
    ) {
        providerDelegate.reportIncomingCall(
            uuid: uuid,
            handle: handle,
            hasVideo: hasVideo,
            completion: completion)
    }
}
