//
//  File.swift
//
//
//  Created by Yanun on 2022/5/9.
//

import Foundation
import SwiftUI

extension Alignment {
    var textAlignment: TextAlignment {
        switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .center:
                return .center
            default:
                return .center
        }
    }
}
