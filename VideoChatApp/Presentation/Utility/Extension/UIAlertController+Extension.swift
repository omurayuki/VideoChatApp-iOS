import Foundation
import UIKit

extension UIAlertController {
    
    static func createAlert(title: String,
                            message: String,
                            handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Resources.Strings.General.yes,
                                     style: .default,
                                     handler: handler)
        let cancelAction = UIAlertAction(title: Resources.Strings.General.no,
                                         style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}

extension UIAlertController {
    
    class func createTwoButton(title: String?,
                               message: String,
                               left: String,
                               right: String,
                               leftCompletion: (() -> Void)? = nil,
                               rightCompletion: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(
            title: title ?? "",
            message: message,
            preferredStyle: .alert)
        
        let leftAction = UIAlertAction(title: left, style: .default) { _ -> Void in
            if let completion = leftCompletion {
                completion()
            }
        }
        
        let rightAction = UIAlertAction(title: right, style: .default) { _ -> Void in
            if let completion = rightCompletion {
                completion()
            }
        }
        
        alert.addAction(leftAction)
        alert.addAction(rightAction)
        
        return alert
    }
    
    class func createOneButton(title: String?,
                               message: String,
                               button: String,
                               completion: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(
            title: title ?? "",
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: button, style: .default) { _ -> Void in
            if let completion = completion {
                completion()
            }
        }
        
        alert.addAction(action)
        return alert
    }
    
    class func createSimpleOkMessage(title: String?,
                                     message: String,
                                     completion: (() -> Void)? = nil) -> UIAlertController {
        return createOneButton(title: title,
                               message: message,
                               button: Resources.Strings.General.ok,
                               completion: completion)
    }
    
    class func createNetworkError() -> UIAlertController {
        return createSimpleOkMessage(title: Resources.Strings.Error.displayTitle,
                                     message: Resources.Strings.Error.noNetworkConnection,
                                     completion: nil)
    }
    
    class func createActionSheet(title: String,
                                 message: String,
                                 okCompletion: (() -> Void)? = nil,
                                 cancelCompletion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: Resources.Strings.General.ok,
                                          style: UIAlertAction.Style.default,
                                          handler: { _ -> Void in
            if let completion = okCompletion {
                completion()
            }
        })
        let cancelAction = UIAlertAction(title: Resources.Strings.General.cancel,
                                         style: .cancel,
                                         handler: { _ -> Void in
            if let completion = cancelCompletion {
                completion()
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        return alert
    }
    
    @discardableResult
    func addAction(title: String?,
                   style: UIAlertAction.Style = .default,
                   handler: ((UIAlertAction) -> Swift.Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title,
                                   style: style,
                                   handler: handler)
        self.addAction(action)
        return action
    }
}
