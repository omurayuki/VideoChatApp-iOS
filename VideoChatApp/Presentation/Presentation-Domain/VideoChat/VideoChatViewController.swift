import Foundation
import UIKit
import SkyWay
import AVFoundation

final class VideoChatViewController: UIViewController {
    
    var routing: VideoChatRoutingProtocol?
    
    private var callManager: CallManager!
    private lazy var skyWayManager: SkyWayManager = {
        let skwManager = SkyWayManager()
        skwManager.delegate = self
        return skwManager
    }()
    
    private lazy var callingStartBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: Resources.Strings.App.startCall,
                                  style: .plain,
                                  target: self,
                                  action: nil)
        btn.action = #selector(startCalling(_:))
        return btn
    }()
    
    private lazy var callingEndBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: Resources.Strings.App.endCall,
                                  style: .plain,
                                  target: self,
                                  action: nil)
        btn.action = #selector(endCalling(_:))
        return btn
    }()

    @IBOutlet weak var localStreamView: SKWVideo!
    @IBOutlet weak var remoteStreamView: SKWVideo!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        do {
            try addReachabilityObserver()
        } catch {
            Logger.debug("can't observe Reachiability.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissionAudio()
        skyWayManager.setupPeer()
        setupCallManager { [unowned self] in self.skyWayManager.call() }
    }
    
    deinit {
        skyWayManager.destroyPeer()
        removeReachabilityObserver()
    }
}

extension VideoChatViewController {
    
    @objc func startCalling(_ sender: UIBarButtonItem) {
        skyWayManager.getAccessPeerIds()
    }
    
    @objc func endCalling(_ sender: UIBarButtonItem) {
        showAlert(message: Resources.Strings.App.messageFinishCalling,
                  actionTitle: Resources.Strings.General.yes,
                  leftCompletion: nil) { [unowned self] in
            self.skyWayManager.close()
        }
    }
    
    private func setupNav() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationController?.navigationBar.topItem?.rightBarButtonItems
            = [callingStartBtn ,callingEndBtn]
        edgesForExtendedLayout = []
    }
    
    private func setupCallManager(_ execute: (() -> Void)?) {
        callManager = AppDelegate.shared.callManager
        callManager.callsAnsweredHandler = { execute?() }
    }
    
    private func checkPermissionAudio() {
        AVCaptureDevice.checkPermissionAudio(
            denied: {
                showAlertWithPermissionUsingMicrophone()
            }, restricted: {
                showAlertWithRestrictedMicrophone()
            })
    }
}

extension VideoChatViewController: SkyWayManagerDelegate {

    func didSetupStream(_ peer: SKWPeer?) {
        skyWayManager.addLocalVideoRenderer(with: localStreamView)
    }

    func setupRemoteStreamRenderer(_ peer: SKWPeer?) {
        skyWayManager.addRemoteVideoRenderer(with: remoteStreamView)
    }

    func didCallDataConnection(_ peer: SKWPeer?) {
        AppDelegate.shared.displayIncomingCall(uuid: UUID(),
                                               hasVideo: true,
                                               completion: nil)
    }

    func removeRemoteStreamRenderer(_ peer: SKWPeer?) {
        skyWayManager.removeRemoteVideoRenderer(with: remoteStreamView)
    }

    func didCloseDataConnection(_ peer: SKWPeer?) {
        guard let call = callManager.calls.first else { return }
        callManager.end(call: call)
    }
    
    func didGetAccessPeerIds(_ peer: SKWPeer?, peerIds: [String]) {
        guard let identity = peer?.identity else { return }
        showListAlert(title: Resources.Strings.App.accessingPeerId,
                      message: Resources.Strings.App.selectPeerId,
                      list: peerIds,
                      compared: identity)
        { [unowned self] peerId in
            self.callManager.startCall(videoEnabled: true)
            self.skyWayManager.connect(target: peerId)
        }
    }
    
    func failedGetAccessPeerIds(_ peer: SKWPeer?) {
        showCancelAlert(title: Resources.Strings.App.accessingPeerId,
                        message: Resources.Strings.App.noPeerId)
    }
}

extension VideoChatViewController: ReachabilityObserverDelegate {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            showAutomaticallyDisappearAlert(title: Resources.Strings.Error.errorTitle,
                                            message: Resources.Strings.Error.errorMessageNetwork,
                                            deadline: .now() + 1.5)
        }
    }
}

extension VideoChatViewController: StoryboardInstantiable { }
