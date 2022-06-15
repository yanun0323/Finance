//
//  SwiftUIView.swift
//  
//
//  Created by Yanun on 2022/5/8.
//

import SwiftUI

struct AdderView: View {
    @EnvironmentObject var content: ContentViewModel
    @FocusState var focusedField: FocusField?
    @State var inputDate = Date.now
    @State var inputCost = ""
    @State var inputDescription = ""
    
    @State private var added = false
    
    private var blockAdd: Bool {
        let cost = Decimal(string: inputCost)
        return inputCost.isEmpty || cost == nil || cost == 0
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 1){
                VStack{
                    HStack {
                        Text("新增一筆花費")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.theme.primary)
                        Spacer()
                        
                        Button(action: {
                            content.Dismiss()
                        }, label: {
                            Image(systemName: "multiply")
                                .font(.title)
                        })
                    }.padding()
                    
                    HStack {
                        Text("日期").fontWeight(.medium)
                        Spacer()
                        MyDateRangePicker(datePicked: $inputDate,
                                          start: content.currentBudget.dateStart,
                                          end: content.currentBudget.dateEnd,
                                          color: content.currentColor)
                            .font(.title3)
                            .padding(.horizontal)
                            .onTapGesture {
                                content.isDatePickerShown = true
                            }
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("金額").fontWeight(.medium)
                        Spacer()
                        TextField("", text: $inputCost)
                            .padding(.horizontal)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .font(.title3)
                            .focused($focusedField, equals: .field)
                            .placeholder(when: inputCost.isEmpty, alignment: .trailing){
                                Text("輸入花費金額")
                                    .foregroundColor(.theme.secondary)
                                    .padding()
                            }
                            .onTapGesture {
                                return
                            }
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("備註").fontWeight(.medium)
                        Spacer()
                        MyTextField(text: $inputDescription, description: "(可空白)", alignment: .trailing, keyboard: .default)
                            .font(.title3)
                            .focused($focusedField, equals: .other)
                            .onTapGesture {
                                return
                            }
                    }.padding([.horizontal, .bottom])
                }.padding(.bottom)
                .background(Color.theme.background.opacity(0.9))
                
                Button(action: {
                    let value = Decimal(string: inputCost) ?? 0
                    if value == 0 { return }
                    added = true
                    content.currentBudget.AddInvoice(
                        InvoiceModel(date: inputDate, cost: value, description: inputDescription)
                    )
                    content.Dismiss()
                    
                }, label: {
                    Rectangle()
                        .foregroundColor(.theme.background.opacity(0.9))
                        .frame(maxHeight: Config.buttonHeight)
                        .overlay{
                            Text("新增")
                                .fontWeight(.regular)
                                .foregroundColor(blockAdd ?
                                    .theme.secondary : content.currentColor)
                        }
                })
                .disabled(blockAdd || added)
            }
            .font(.title3)
            .lineLimit(1)
            .foregroundColor(Color.theme.primary)
            .cornerRadius(Config.cornerRadius)
            .padding()
            .onTapGesture {
                content.isDatePickerShown = false
                UIApplication.shared.DismissKeyboard()
            }
            .onAppear{
                self.focusedField = .field
            }
            
        }
    }
}
