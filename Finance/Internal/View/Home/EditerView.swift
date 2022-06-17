//
//  SwiftUIView.swift
//  
//
//  Created by Yanun on 2022/5/9.
//

import SwiftUI

struct BudgetEditerView: View  {
    @EnvironmentObject var content: ContentViewModel
    @FocusState var focusedField: FocusField?
    @State var inputName: String = ""
    @State var inputBudget = ""
    @State var inputColor = CardColor.purple
    @State var inputDateStart = Date.now
    @State var inputDateEnd = Date.now
    @State var inputRepeated: Repeated = .month
    
    @State private var created = false
    
    let rowHeight: CGFloat = 35
    
    private var blockEnd: Bool {
        inputRepeated != .none
    }
    private var blockAdd: Bool {
        let budget = Decimal(string: inputBudget)
        return inputName.isEmpty || budget == nil || budget == 0
    }
    
    var body: some View {
        VStack(spacing: 1){
            VStack(spacing: 5){
                HStack {
                    Text("編輯預算卡")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.theme.primary)
                    Spacer()
                    Button(action: {
                        withAnimation(Config.deafult){
                            content.Dismiss()
                        }
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.title)
                    })
                }
                .padding()
                
                HStack{
                    Text("名稱").fontWeight(.medium)
                    MyTextField(text: $inputName, description: "輸入卡片名稱", alignment: .trailing, keyboard: .default)
                        .frame(height: rowHeight)
                        .focused($focusedField, equals: .field)
                        .onTapGesture {
                            return
                        }
                }.padding(.horizontal)
                
                
                HStack{
                    Text("預算").fontWeight(.medium)
                    MyTextField(text: $inputBudget, description: "輸入預算", alignment: .trailing, keyboard: .decimalPad)
                        .frame(height: rowHeight)
                        .focused($focusedField, equals: .other)
                        .onTapGesture {
                            return
                        }
                }.padding(.horizontal)
                
                HStack{
                    HStack{
                        Text("顏色").fontWeight(.medium)
                        Spacer()
                        Menu(content: {
                            Picker(selection: $inputColor, content: {
                                ForEach(CardColor.allCases) { value in
                                    Text(value.name).tag(value)
                                }
                            }, label: {})
                        }, label: {
                            Text(" ")
                                .padding(.horizontal)
                                .background(inputColor.render)
                        })
                        Spacer()
                    }
                    HStack{
                        Text("重複").fontWeight(.medium)
                        Spacer()
                        Menu(content: {
                            Picker(selection: $inputRepeated, content: {
                                ForEach(Repeated.allCases) { value in
                                    Text(value.name).tag(value)
                                }
                            }, label: {})
                        }, label: {
                            Text(inputRepeated.name)
                                .font(.headline)
                                .foregroundColor(inputColor.render)
                                .padding(.horizontal)
                        })
                    }
                }.padding()
                
                
                
                HStack {
                    Text("開始日期").fontWeight(.medium)
                    Spacer()
                    MyDatePicker(datePicked: $inputDateStart, color: inputColor.render)
                        .font(.title3)
                        .padding(.horizontal)
                        .onTapGesture {
                            content.isDatePickerShown = true
                        }
                }.padding(.horizontal)
                
                HStack {
                    Text("結束日期").fontWeight(.medium).foregroundColor(blockEnd ? .theme.secondary : .theme.primary)
                    Spacer()
                    MyDateRangePicker(datePicked: $inputDateEnd, start:inputDateStart, end: nil, color: inputColor.render)
                        .font(.title3)
                        .foregroundColor(blockEnd ? .theme.secondary : .theme.primary)
                        .padding(.horizontal)
                        .onTapGesture {
                            if blockEnd { return }
                            content.isDatePickerShown = true
                        }
                }.padding([.horizontal, .bottom]).disabled(blockEnd)
            }
            .background(Color.theme.background.opacity(0.9))
            
            Button(action: {
                let value = Decimal(string: inputBudget) ?? 0
                if value == 0 { return }
                let budget = BudgetModel(
                    name: inputName,
                    budget: value,
                    color: inputColor,
                    dateStart: inputDateStart,
                    dateEnd: inputDateEnd,
                    repeate: inputRepeated,
                    invoices: content.currentBudget.invoices
                )
                
                withAnimation(Config.deafult){
                    created = true
                    content.budgets[content.budgetIndex] = budget
                    content.showBudgetEditer = false
                }
            }, label: {
                Rectangle()
                    .foregroundColor(.theme.background.opacity(0.9))
                    .frame(maxHeight: Config.buttonHeight)
                    .overlay{
                        Text("修改")
                            .fontWeight(.regular)
                            .foregroundColor(blockAdd ?
                                .theme.secondary : inputColor.render)
                    }.disabled(blockAdd || created)
            })
        }
        .font(.title3)
        .lineLimit(1)
        .foregroundColor(Color.theme.primary)
        .cornerRadius(Config.cornerRadius)
        .padding()
        .onAppear{
            inputName = content.currentBudget.name
            inputBudget = content.currentBudget.budget.description
            inputColor = content.currentBudget.color
            inputDateStart = content.currentBudget.dateStart
            inputDateEnd = content.currentBudget.dateEnd ?? Date.now
            inputRepeated = content.currentBudget.repeated
        }
        .onTapGesture {
            content.isDatePickerShown = false
            UIApplication.shared.DismissKeyboard()
        }
        .onAppear{
            self.focusedField = .field
        }
    }
}

struct BudgetEditerView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetEditerView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
        InvoiceEditerView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}

struct InvoiceEditerView: View  {
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
                        Text("修改花費")
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
                    withAnimation(Config.deafult){
                        let newInvoice = InvoiceModel(date: inputDate, cost: value, description: inputDescription)
                        content.currentBudget.EditInvoice(old: content.currentInvoice, new: newInvoice)
                        content.currentInvoice = InvoiceModel(date: Date.now, cost: 0)
                        content.Dismiss()
                    }
                }, label: {
                    Rectangle()
                        .foregroundColor(.theme.background.opacity(0.9))
                        .frame(maxHeight: Config.buttonHeight)
                        .overlay{
                            Text("修改")
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
                inputDate = content.currentInvoice.date
                inputCost = content.currentInvoice.cost.description
                inputDescription = content.currentInvoice.description ?? ""
            }
        }
    }
}
