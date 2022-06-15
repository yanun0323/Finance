import SwiftUI

struct CreaterView: View {
    @EnvironmentObject var content: ContentViewModel
    @FocusState var focusedField: FocusField?
    @State var inputName = ""
    @State var inputBudget = ""
    @State var inputColor = CardColor.cyan
    @State var inputDateStart = Date.now
    @State var inputDateEnd = Date.now
    @State var inputRepeated: Repeated = .month
    
    @State var created = false

    
    let rowHeight: CGFloat = 35
    
    private var blockAdd: Bool {
        let budget = Decimal(string: inputBudget)
        return inputName.isEmpty || budget == nil || budget == 0
    }
    private var blockEnd: Bool {
        inputRepeated != .none
    }
    
    var body: some View {
        VStack(spacing: 1) {
            VStack {
                HStack {
                    Text("新增預算卡")
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
                    }.transition(.opacity)
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
                    MyDateRangePicker(datePicked: $inputDateEnd,start:inputDateStart, end: nil, color: inputColor.render)
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
                created = true
                let budget = BudgetModel(
                    name: inputName,
                    budget: value,
                    color: inputColor,
                    dateStart: inputDateStart,
                    dateEnd: inputRepeated == .none || inputRepeated == .forever ? nil : inputDateEnd,
                    repeate: inputRepeated,
                    invoices: [:])
                withAnimation(Config.deafult){
                    content.budgets.append(budget)
                    content.Dismiss()
                }
            }, label: {
                Rectangle()
                    .foregroundColor(.theme.background.opacity(0.9))
                    .frame(maxHeight: Config.buttonHeight)
                    .overlay{
                        Text("新增")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(blockAdd ?
                                .theme.secondary : inputColor.render)
                    }
            
            }).disabled(blockAdd || created)
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
