import Foundation

struct Keys: Hashable, Encodable, RawRepresentable {
    
    let rawValue: String
    
    static let apiError = Keys(rawValue: "apiError")!
    static let callError = Keys(rawValue: "callError")!
    static let dataConnectError = Keys(rawValue: "dataConnectError")!
    static let connectPeerError = Keys(rawValue: "connectPeerError")!
    static let listFetchingError = Keys(rawValue: "listFetchingError")!
    
    init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Encodable where Self == Keys {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}
