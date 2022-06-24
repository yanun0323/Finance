import SwiftUI

enum CardColor: Identifiable, CaseIterable {
    var id: String { self.name }
    
    case red
    case orange
    case yellow
    case green
    case cyan
    case purple
    case blue
    case gray
    case black
    
    var render: Color {
        switch self {
        case .red:
            return .red
        case .orange:
            return .orange
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .cyan:
            return .cyan
        case .purple:
            return .purple
        case .blue:
            return .blue
        case .gray:
            return .gray
        case .black:
            return .black
        }
    }
    
    var name: String {
        switch self {
        case .red:
            return "紅"
        case .orange:
            return "橘"
        case .yellow:
            return "黃"
        case .green:
            return "綠"
        case .cyan:
            return "藍"
        case .purple:
            return "紫"
        case .black:
            return "黑"
        case .gray:
            return "灰"
        case .blue:
            return "靛"
        }
    }
}
