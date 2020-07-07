import AVFoundation
import CallKit

class CallProvider: NSObject {
    
    private let callManager: CallManager
    private let provider: CXProvider
    private let audio: Audio
    
    init(callManager: CallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: CallProvider.providerConfiguration)
        audio = Audio()
        
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    static var providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration = CXProviderConfiguration(localizedName: Resources.Strings.App.appName)
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        return providerConfiguration
    }()
    
    func reportIncomingCall(
        uuid: UUID,
        handle: String?,
        hasVideo: Bool = false,
        completion: ((Error?) -> Void)?
    ) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic,
                                       value: handle ?? Resources.Strings.App.unknown)
        update.hasVideo = hasVideo
    
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error.isNone {
                let call = Call(uuid: uuid,
                                handle: handle ?? Resources.Strings.App.unknown)
                self.callManager.add(call: call)
            }
            
            completion?(error)
        }
    }
}

// MARK: - CXProviderDelegate
extension CallProvider: CXProviderDelegate {
    
    func providerDidReset(_ provider: CXProvider) {
        audio.stop()
        callManager.calls.forEach { $0.end() }
        callManager.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
    
        audio.configureSession()
        callManager.answer()
        call.answer()
        action.fulfill()
    }
  
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        audio.start()
    }
  
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
    
        audio.stop()
        call.end()
        action.fulfill()
        callManager.remove(call: call)
    }
  
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
    
        call.state = action.isOnHold ? .held : .active
        call.state == .held ? audio.stop() : audio.start()
        action.fulfill()
    }
  
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call(uuid: action.callUUID, outgoing: true,
                        handle: action.handle.value)

        audio.configureSession()

        call.connectedStateChanged = { [weak self, weak call] in
            guard
                let self = self, let call = call
            else {
                return
            }
            
            switch call.connectedState {
            case .pending:
                self.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: nil)
                
            case .complete:
                self.provider.reportOutgoingCall(with: call.uuid, connectedAt: nil)
            }
        }

        call.start { [weak self, weak call] success in
            guard
                let self = self, let call = call
            else {
                return
            }
      
            if success {
                action.fulfill()
                self.callManager.add(call: call)
            } else {
                action.fail()
            }
        }
    }
}
