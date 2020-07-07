import Foundation
import UIKit

public struct SizeResources {
    public var Duration: AnimationDurationResource = AnimationDurationResource()
    public var Margins: UIMarginResource = UIMarginResource()
    public var timeInterval: DispatchTimeIntervalResource = DispatchTimeIntervalResource()
    
    public init() {}
}

/**
 MARK: - UI Margins
 */

public struct UIMarginResource {
    /** 0.0 */
    /** public static var none: CGFloat = 0.00 **/
    
    public init() {}
}

/**
 MARK: - Animation Duration
 */

public struct AnimationDurationResource {
    /** 0.00 Sec */
    /** public var none: TimeInterval = 0.00 **/
    
    public init() {}
}

public struct DispatchTimeIntervalResource {
    
    /** public var fast: DispatchTimeInterval = .milliseconds(25) **/
    
    public init() {}
}
