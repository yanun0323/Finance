//
//  SwiftUIView.swift
//  
//
//  Created by Yanun on 2022/5/9.
//

import SwiftUI

struct MyTextField: View {
    @Binding var text: String
    let description: String
    let alignment: Alignment
    let keyboard: UIKeyboardType
    
    var body: some View {
        TextField("", text: $text)
            .labelsHidden()
            .padding(.horizontal)
            .keyboardType(keyboard)
            .multilineTextAlignment(alignment.textAlignment)
            .placeholder(when: text.isEmpty, alignment: alignment){
                Text(description)
                    .foregroundColor(.theme.secondary)
                    .padding(.horizontal)
            }
    }
}
