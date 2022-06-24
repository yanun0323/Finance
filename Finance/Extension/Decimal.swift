import SwiftUI

extension Decimal {
    var ToCGFloat: CGFloat {
        return CGFloat((self as NSDecimalNumber).floatValue)
    }
}
