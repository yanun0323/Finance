import SwiftUI

extension Color {
    static let theme = ThemeColor()
}

struct ThemeColor {
    let primary: Color = .black
    let background: Color = .white
    let shadow: Color = .black.opacity(0.3)
    let accent: Color = .init(red: 0, green: 0.5, blue: 1)

    let secondary: Color = .init(red: 0.8, green: 0.8, blue: 0.8)
    let error: Color = .red

    let textField: Color = .init(red: 0.97, green: 0.97, blue: 0.97)

    let green: Color = .init(red: 0.3, green: 0.75, blue: 0)
}
