import Foundation
import SkyWay

/// SkyWayManager用のDelegate protocol
protocol SkyWayManagerDelegate: NSObject {

    /// ローカルメディアストリームの設定が完了した際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didSetupStream(_ peer: SKWPeer?)

    /// リモートの映像がレンダリングされた際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func setupRemoteStreamRenderer(_ peer: SKWPeer?)

    /// リモートの映像が破棄された際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func removeRemoteStreamRenderer(_ peer: SKWPeer?)

    /// リモートPeerからのデータ接続が発生し、DataConnectionオブジェクトが存在した際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didCallDataConnection(_ peer: SKWPeer?)

    /// MediaConnectionに接続成功した際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didCallMediaConnection(_ peer: SKWPeer?)

    /// DataConnectionが切断された際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didCloseDataConnection(_ peer: SKWPeer?)

    /// MediaConnectionが切断された際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didCloseMediaConnection(_ peer: SKWPeer?)

    /// 特定のPeerと接続成功した際に発火
    /// - Parameter peer: 自身のPeerオブジェクト
    func didConnectWithTargetPeer(_ peer: SKWPeer?)

    /// PeerIdの配列を取得できた際に発火
    /// - Parameters:
    ///   - peer: 自身のPeerオブジェクト
    ///   - peerIds: シグナリングサーバーに接続された全てのPeerオブジェクト
    func didGetAccessPeerIds(_ peer: SKWPeer?, peerIds: [String])

    /// 自身のPeerの破棄(peer.destroy())が成功した際に発火
    func didDestroyPeer()
}

extension SkyWayManagerDelegate {

    func didCallDataConnection(_ peer: SKWPeer?) { }

    func didCallMediaConnection(_ peer: SKWPeer?) { }

    func didCloseDataConnection(_ peer: SKWPeer?) { }

    func didCloseMediaConnection(_ peer: SKWPeer?) { }

    func didConnectWithTargetPeer(_ peer: SKWPeer?) { }

    func didGetAccessPeerIds(_ peer: SKWPeer?, peerIds: [String]) { }

    func didDestroyPeer() { }
}
