import Foundation

struct StringResources {
        
    private typealias Internal = R.string

    struct App {
        
        static var call: String
            { return Internal.localizable.call() }
        static var messageCalling: String
            { return Internal.localizable.message_calling() }
        static var appName: String
            { return Internal.localizable.app_name() }
        static var startCall: String
            { return Internal.localizable.start_call() }
        static var endCall: String
            { return Internal.localizable.end_call() }
        static var messageFinishCalling: String
            { return Internal.localizable.message_finish_calling() }
        static var unknown: String
            { return Internal.localizable.unknown() }
        static var accessingPeerId: String
            { return Internal.localizable.accessing_peer_id() }
        static var selectPeerId: String
            { return Internal.localizable.select_peer_id() }
        static var noPeerId: String
            { return Internal.localizable.no_peer_id() }
    }
    
    struct General {
        
        static var yes: String
            { return Internal.localizable.yes() }
        static var no: String
            { return Internal.localizable.no() }
        static var ok: String
            { return Internal.localizable.ok() }
        static var cancel: String
            { return Internal.localizable.cancel() }
        static var attension: String
            { return Internal.localizable.attension() }
        static var success: String
            { return Internal.localizable.success() }
        static var permissionMicrophoneTitle: String
            { return Internal.localizable.permission_microphone_title() }
        static var permissionMicrophoneMessage: String
            { return Internal.localizable.permission_microphone_message() }
        static var openSettingsTitle: String
            { return Internal.localizable.open_settings_title() }
        static var restreictedMicrophoneMessage: String
            { return Internal.localizable.restreicted_microphone_message() }
    }
    
    struct Error {
        
        static var displayTitle: String
            { return Internal.localizable.error_title() }
        static var noNetworkConnection: String
            { return Internal.localizable.error_message_network() }
    }
}
