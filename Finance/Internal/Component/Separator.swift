//
//  Separator.swift
//  app_twss
//
//  Created by Yanun on 2022/5/30.
//

import SwiftUI

struct Separator: View {
    enum Direction {
        case vertical
        case horizontal
    }
    let direction: Direction
    var color: Color?
    var length: CGFloat?
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: length ?? 0)
            .foregroundColor(color ?? .black)
            .frame(width: direction == .vertical ? length ?? 1 : nil, height: direction == .vertical ? nil : length ?? 1)
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        Separator(direction: .horizontal)
    }
}
