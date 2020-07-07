import Foundation
import SkyWay

final class SkyWayManager {

    private var skyWayErrorHandler: SkyWayErrorHandler?
    private var dataConnection: SKWDataConnection?
    private var mediaConnection: SKWMediaConnection?
    private var localStream: SKWMediaStream?
    private var remoteStream: SKWMediaStream?
    private var peer: SKWPeer? {
        didSet {
            setupPeerCallBacks()
            setupStream()
        }
    }

    weak var delegate: SkyWayManagerDelegate?

    func setupPeer(with id: String? = nil) {
        let options = SKWPeerOption()
        options.key = Config.App.currentSkyWayAPIKey
        options.domain = Config.App.currentSkyWayDomain
        id.isNone ?
            (peer = SKWPeer(options: options)) :
            (peer = SKWPeer(id: id, options: options))
    }

    func close() {
        dataConnection?.close()
        mediaConnection?.close()
    }

    func addLocalVideoRenderer(with localView: SKWVideo) {
        localStream?.addVideoRenderer(localView, track: 0)
    }

    func addRemoteVideoRenderer(with remoteView: SKWVideo) {
        remoteStream?.addVideoRenderer(remoteView, track: 0)
    }

    func removeLocalVideoRenderer(with localView: SKWVideo) {
        localStream?.removeVideoRenderer(localView, track: 0)
    }

    func removeRemoteVideoRenderer(with remoteView: SKWVideo) {
        remoteStream?.removeVideoRenderer(remoteView, track: 0)
    }
    
    func destroyPeer() {
        peer?.destroy()
    }
}

// MARK: Peer Setup
extension SkyWayManager {

    private func setupPeerCallBacks() {
        peer?.on(.PEER_EVENT_ERROR) { [weak self] obj in
            self?.skyWayErrorHandler?.synthesizeApiError((obj as? SKWPeerError)) {
                NotificationCenter.default.post(name: Notification.Name("fuga"), object: $0)
            }
        }

        peer?.on(.PEER_EVENT_OPEN) { obj in }

        peer?.on(.PEER_EVENT_CALL) { [weak self] obj in
            if let mc = obj as? SKWMediaConnection {
                self?.setupMediaConnectionCallbacks(mediaConnection: mc)
                self?.mediaConnection = mc
                mc.answer(self?.localStream)
            }
        }

        peer?.on(.PEER_EVENT_CONNECTION) { [weak self] obj in
            if let connection = obj as? SKWDataConnection {
                if self?.dataConnection == nil {
                    self?.delegate?.didCallDataConnection(self?.peer)
                }
                self?.dataConnection = connection
                self?.setupDataConnectionCallbacks(dataConnection: connection)
            }
        }

        peer?.on(.PEER_EVENT_CLOSE) { [weak self] _ in
            self?.delegate?.didDestroyPeer()
        }
    }

    private func setupStream() {
        guard let peer = peer else { return }
        SKWNavigator.initialize(peer)
        let constraints = SKWMediaConstraints()
        constraints.cameraPosition = .CAMERA_POSITION_FRONT
        localStream = SKWNavigator.getUserMedia(constraints)
        delegate?.didSetupStream(peer)
    }

    private func setupMediaConnectionCallbacks(mediaConnection: SKWMediaConnection) {
        mediaConnection.on(.MEDIACONNECTION_EVENT_STREAM) { [weak self] obj in
            if let msStream = obj as? SKWMediaStream {
                self?.remoteStream = msStream
                DispatchQueue.main.async {
                    self?.delegate?.setupRemoteStreamRenderer(self?.peer)
                }
                self?.delegate?.didCallMediaConnection(self?.peer)
            }
        }

        mediaConnection.on(.MEDIACONNECTION_EVENT_CLOSE) { [weak self] obj in
            if let _ = obj as? SKWMediaConnection {
                DispatchQueue.main.async {
                    self?.delegate?.removeRemoteStreamRenderer(self?.peer)
                    self?.remoteStream = nil
                    self?.dataConnection = nil
                    self?.mediaConnection = nil
                }
                self?.delegate?.didCloseMediaConnection(self?.peer)
            }
        }
    }

    private func setupDataConnectionCallbacks(dataConnection: SKWDataConnection) {
        dataConnection.on(.DATACONNECTION_EVENT_OPEN) { obj in }

        dataConnection.on(.DATACONNECTION_EVENT_CLOSE) { [weak self] obj in
            self?.dataConnection = nil
            self?.delegate?.didCloseDataConnection(self?.peer)
        }
    }
}

// MARK: related calling
extension SkyWayManager {

    func call() {
        if let peerId = dataConnection?.peer {
            let option = SKWCallOption()
            if let mc = peer?.call(withId: peerId, stream: localStream, options: option) {
                mediaConnection = mc
                setupMediaConnectionCallbacks(mediaConnection: mc)
            } else {
                skyWayErrorHandler?.synthesizeClientError(type: .call) {
                    NotificationCenter.default.post(name: Notification.Name("call"), object: $0)
                }
            }
        } else {
            skyWayErrorHandler?.synthesizeClientError(type: .dataConnect) {
                NotificationCenter.default.post(name: Notification.Name("dataConnect"), object: $0)
            }
        }
    }

    func connect(target peerId: String) {
        let options = SKWConnectOption()
        options.serialization = .SERIALIZATION_BINARY
        if let dc = peer?.connect(withId: peerId, options: options) {
            dataConnection = dc
            setupDataConnectionCallbacks(dataConnection: dc)
            delegate?.didConnectWithTargetPeer(peer)
        } else {
            skyWayErrorHandler?.synthesizeClientError(type: .listFetching) {
                NotificationCenter.default.post(name: Notification.Name("listFetching"), object: $0)
            }
        }
    }

    func getAccessPeerIds() {
        peer?.listAllPeers() { [weak self] lists in
            guard let peerIds = lists as? [String] else {
                // エラーハンドリング
                return
            }
            peerIds.isEmpty ?
                self?.delegate?.failedGetAccessPeerIds(self?.peer) :
                self?.delegate?.didGetAccessPeerIds(self?.peer, peerIds: peerIds)
        }
    }
}
