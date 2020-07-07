import Foundation
import UIKit

extension UIViewController {
    
    func setUserInteraction(enabled: Bool) {
        view.isUserInteractionEnabled = enabled
        if let navi = navigationController {
            navi.view.isUserInteractionEnabled = enabled
        }
    }
    
    func showAlert(title: String? = nil,
                   message: String,
                   actionTitle: String,
                   leftCompletion: (() -> Void)? = nil,
                   rightCompletion: (() -> Void)? = nil) {
        let alert = UIAlertController.createTwoButton(title: title,
                                                      message: message,
                                                      left: Resources.Strings.General.cancel,
                                                      right: actionTitle,
                                                      leftCompletion: {
            if let completion = leftCompletion {
                completion()
            }
        }) {
            if let completion = rightCompletion {
                completion()
            }
        }
        self.present(alert, animated: true)
    }
    
    func showListAlert(title: String,
                       message: String,
                       list: [String],
                       compared: String,
                       handler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        list.forEach { element in
            if element != compared {
                let action = UIAlertAction(title: element,
                                           style: .default,
                                           handler: { _ in
                                                handler(element)
                })
                alert.addAction(action)
            }
        }
        let noAction = UIAlertAction(title: Resources.Strings.General.cancel,
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showCancelAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let noAction = UIAlertAction(title: Resources.Strings.General.cancel,
                                     style: .cancel,
                                     handler: nil)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        let alert = UIAlertController
            .createSimpleOkMessage(title: Resources.Strings.Error.errorTitle,
                                   message: message)
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController
            .createSimpleOkMessage(title: Resources.Strings.General.success,
                                   message: message)
        present(alert, animated: true)
    }
    
    func showAttentionAlert(message: String) {
        let alert = UIAlertController
            .createSimpleOkMessage(title: Resources.Strings.General.attension,
                                   message: message)
        self.present(alert, animated: true)
    }
    
    func showAlertSheet(title: String,
                        message: String?,
                        actionTitle: String,
                        completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle,
                                   style: .default) { _ -> Void in completion?() }
        
        let cancelAction = UIAlertAction(title: Resources.Strings.General.no,
                                         style: .cancel,
                                         handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String,
                         message: String,
                         completion: @escaping () -> Void) {
        let alert = UIAlertController.createActionSheet(title: title,
                                                        message: message,
                                                        okCompletion: { completion() })
        present(alert, animated: true)
    }
    
    func showAutomaticallyDisappearAlert(title: String,
                                         message: String,
                                         deadline: DispatchTime,
                                         handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                alert.dismiss(animated: true)
                handler?()
            })
        })
    }
    
    func showAlertWithPermissionUsingMicrophone() {
        let alert = UIAlertController(title: Resources.Strings.General.permissionMicrophoneTitle,
                                      message: Resources.Strings.General.permissionMicrophoneMessage,
                                      preferredStyle: .alert)
        
        let settings = UIAlertAction(title: Resources.Strings.General.openSettingsTitle,
                                     style: .default) { result in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
        
        alert.addAction(settings)
        alert.addAction(UIAlertAction(title: Resources.Strings.General.cancel,
                                      style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithRestrictedMicrophone() {
        let alert = UIAlertController(title: nil,
                                      message: Resources.Strings.General.restreictedMicrophoneMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Resources.Strings.General.ok,
                                      style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
}
