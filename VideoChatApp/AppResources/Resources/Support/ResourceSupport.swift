import UIKit

protocol Initializable: class { }

extension Initializable {
    
    static var className: String {
        return String(describing: self)
    }
    
    static var resourceName: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }
    
    var segueName: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }

    static var segueName: String {
        return self.className
    }
}
