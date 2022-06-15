//
//  File.swift
//  
//
//  Created by Yanun on 2022/5/8.
//

import SwiftUI

extension String {
    var IsNumber: Bool{
        if self.isEmpty { return false }
        return self == self.filter { $0.isNumber }
    }
}
