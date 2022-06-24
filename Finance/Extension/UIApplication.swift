//
//  File.swift
//
//
//  Created by Yanun on 2022/5/8.
//
import SwiftUI

extension UIApplication {
    func DismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
