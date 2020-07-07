import AVFoundation

class Audio {
    
    func configureSession() {
        Logger.debug("Configuring audio session")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
        } catch (let error) {
            Logger.error("Error while configuring audio session: \(error)")
        }
    }

    func start() {
        Logger.debug("Starting audio")
    }

    func stop() {
        Logger.debug("Stopping audio")
    }
}
