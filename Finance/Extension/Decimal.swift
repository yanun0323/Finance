import SwiftUI

extension Decimal {
    var ToCGFloat: CGFloat {
        return CGFloat.init((self as NSDecimalNumber).floatValue)
    }
}
