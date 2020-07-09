import Foundation

struct Keys: Hashable, Encodable, RawRepresentable {
    
    let rawValue: String
    
    static let apiError = Keys(rawValue: "apiError")!
    
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
