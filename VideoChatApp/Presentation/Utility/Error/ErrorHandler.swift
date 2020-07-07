import Foundation

protocol ErrorHandler {
    
    func synthesizeApiError<T>(_ error: T?, handler: (String) -> Void)
}
