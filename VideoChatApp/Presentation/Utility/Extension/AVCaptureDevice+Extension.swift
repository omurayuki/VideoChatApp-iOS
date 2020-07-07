import Foundation
import AVFoundation

extension AVCaptureDevice {
    
    static func checkPermissionAudio(denied: () -> Void,
                                     restricted: () -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            break
            
        case .denied:
            denied()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { result in
                Logger.debug("getAudioPermission: \(result)")
            }
            
        case .restricted:
            restricted()
            
        @unknown default:
            break
        }
    }
}
