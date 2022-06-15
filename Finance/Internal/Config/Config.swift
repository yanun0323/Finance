import SwiftUI

struct Config {
    static let cornerRadius: CGFloat = 15
    static let buttonRadius: CGFloat = 10
    static let shadowRadius: CGFloat = 5
    static let opacitySpeed: CGFloat = 0.2
    static let coverBlur: CGFloat = 5
    
    static let buttonHeight: CGFloat = 50
    
    static let DatePickerFormat: String = "YYYY-MM-dd EE"
    
    static let zero: Animation = .easeInOut(duration: 0.0101)
    static let slide: Animation = .easeOut(duration: 0.15)
    static let deafult: Animation = .easeInOut(duration: 0.15)
}
