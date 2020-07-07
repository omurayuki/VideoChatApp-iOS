import UIKit

protocol StoryboardInstantiable {
    
    static var storyboardName: String { get }
    static var bundle: Bundle? { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var bundle: Bundle? {
        return nil
    }
    
    static var storyboardName: String {
        return String(describing: Self.self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateInitialViewController() as! Self
    }
}
