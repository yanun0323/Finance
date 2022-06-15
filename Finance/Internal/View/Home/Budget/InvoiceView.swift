import SwiftUI

import SwiftUI

struct InvoiceView: View {
    @ObservedObject var content: ContentViewModel
    @ObservedObject var budget: BudgetModel
    
    var body: some View {
        if budget.invoices == [:] {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .overlay {
                        Text("沒有任何花費")
                            .foregroundColor(.theme.secondary)
                            .font(.title3)
                    }
            }
        } else {
            List{
                ForEach(Array(budget.invoices.keys.enumerated()).sorted {
                    return $0.element > $1.element
                }
                        , id: \.element){ (_, key) in
                    if budget.invoices[key]?.count != 0 {
                        DateRowView(date: key)
                        ForEach(budget.invoices[key]!.reversed()) { invoice in
                            RowView(invoice: invoice)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                    HStack {
                                        Button(role: .destructive ,action: {
                                            budget.RemoveInvoice(invoice)
                                            content.RefreshBudget()
                                        }, label: {
                                            Label("Delete", systemImage: "trash")
                                        })
                                        Button(role: .none ,action: {
                                            if content.isCoverd { return }
                                            content.currentInvoice = invoice
                                            withAnimation(Config.slide){
                                                content.showInvoiceEditer = true
                                            }
                                        }, label: {
                                            Label("Edit", systemImage: "square.and.pencil")
                                                .font(.largeTitle)
                                        })
                                    }
                                }
                        }
                    }
                }
                        .listRowSeparator(.hidden)
                        .navigationBarHidden(true)
                        .background(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}

struct DateRowView: View {
    let date: Date
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.clear)
            .overlay{
                HStack{
                    Text(date.String(format: "YYYY.MM.dd EE"))
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.theme.primary)
                        .monospacedDigit()
                    Separator(direction: .horizontal, color: .theme.secondary, length: 1.5)
                }
            }
            .listRowBackground(Color.clear)
    }
}

struct RowView: View {
    let invoice: InvoiceModel
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.clear)
            .overlay{
                HStack {
                    Group{
                        if invoice.description != nil {
                            Text(invoice.description!)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        Spacer()
                        Text(invoice.cost.description)
                            .fontWeight(.medium)
                            .frame(minWidth: 50)
                    }
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.theme.primary)
    
                }.padding(.horizontal)
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal)
    }
}

