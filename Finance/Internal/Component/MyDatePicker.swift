//
//  File.swift
//
//
//  Created by Yanun on 2022/5/9.
//

import SwiftUI

struct MyDatePicker: View {
    @Binding var datePicked: Date
    let color: Color
    let format: String = Config.DatePickerFormat

    var body: some View {
        DatePicker("", selection: $datePicked, displayedComponents: .date)
            .accentColor(color)
            .colorMultiply(.theme.primary)
            .frame(minWidth: 150)
            .opacity(0.0101)
            .labelsHidden()
            .background(Text(datePicked.String(format: format)))
            .monospacedDigit()
        //            .environment(\.locale, Locale(identifier: "zh_Hant_TW"))
        //            .environment(\.calendar, Calendar(identifier: .republicOfChina))
    }
}

struct MyDateRangePicker: View {
    @Binding var datePicked: Date
    let start: Date
    let end: Date?
    let color: Color
    let format: String = Config.DatePickerFormat

    var body: some View {
        if let end = end {
            DatePicker("", selection: $datePicked, in: start ... end,
                       displayedComponents: .date)
                .accentColor(color)
                .colorMultiply(.theme.primary)
                .frame(minWidth: 150)
                .opacity(0.0101)
                .labelsHidden()
                .background(Text(datePicked.String(format: format)))
                .monospacedDigit()
        } else {
            DatePicker("", selection: $datePicked, in: start...,
                       displayedComponents: .date)
                .accentColor(color)
                .colorMultiply(.theme.primary)
                .frame(minWidth: 150)
                .opacity(0.0101)
                .labelsHidden()
                .background(Text(datePicked.String(format: format)))
                .monospacedDigit()
        }
    }
}
