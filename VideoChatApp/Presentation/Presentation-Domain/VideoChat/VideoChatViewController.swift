import Foundation
import UIKit
import SkyWay
import AVFoundation

struct User {
    
    var peerId: String
    var name: String
}

final class VideoChatViewController: UIViewController {
    
    // MARK: Dummy
    var owned = User(peerId: "client-peer", name: "お客様")
    var opponent = User(peerId: "admin-peer", name: "管理者")
    
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
        print("fuga")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissionAudio()
        skyWayManager.setupPeer(with: owned.peerId)
        setupCallManager { [unowned self] in self.skyWayManager.call() }
    }
    
    deinit {
        skyWayManager.peer?.destroy()
    }
}

extension VideoChatViewController {
    
    private func setupNav() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [callingStartBtn ,callingEndBtn]
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
    
    @objc func startCalling(_ sender: UIBarButtonItem) {
        guard let peer = skyWayManager.peer else {
            Logger.debug("coult not salvage peer")
            return
        }
        
        showPeersDialog(peer) { [unowned self] peerId in
            self.callManager.startCall(handle: self.owned.name, videoEnabled: true)
            self.skyWayManager.connect(target: peerId)
        }
    }
    
    @objc func endCalling(_ sender: UIBarButtonItem) {
        showAlert(message: Resources.Strings.App.messageFinishCalling,
                  actionTitle: Resources.Strings.General.yes,
                  leftCompletion: nil) { [unowned self] in
            self.skyWayManager.close()
        }
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
                                               handle: opponent.name,
                                               hasVideo: true,
                                               completion: nil)
    }

    func removeRemoteStreamRenderer(_ peer: SKWPeer?) {
        skyWayManager.removeRemoteVideoRenderer(with: remoteStreamView)
    }

    func didCloseDataConnection(_ peer: SKWPeer?) {
        callManager.end(call: callManager.calls[0])
        routing?.pop(vc: self)
    }
}

extension VideoChatViewController: StoryboardInstantiable { }

extension VideoChatViewController {
    
    func showPeersDialog(_ peer: SKWPeer, handler: @escaping (String) -> Void) {
        peer.listAllPeers() { peers in
            if let peerIds = peers as? [String] {
                if peerIds.count <= 1 {
                    let alert = UIAlertController(title: "接続中のPeerId", message: "接続先がありません", preferredStyle: .alert)
                    let noAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                    alert.addAction(noAction)
                    self.present(alert, animated: true, completion: nil)

                }
                else {
                    let alert = UIAlertController(title: "接続中のPeerId", message: "接続先を選択してください", preferredStyle: .alert)
                    for peerId in peerIds{
                        if peerId != peer.identity {
                            let peerIdAction = UIAlertAction(title: peerId, style: .default, handler: { (alert) in
                                handler(peerId)
                            })
                            alert.addAction(peerIdAction)
                        }
                    }
                    let noAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                    alert.addAction(noAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
