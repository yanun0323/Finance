import SwiftUI

import SwiftUI

class BudgetModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: BudgetModel, rhs: BudgetModel) -> Bool {
        lhs.id == rhs.id
    }
    
    @Published var id: UUID
    @Published var name: String
    @Published var color: CardColor
    @Published var budget: Decimal
    @Published var cost: Decimal = 0
    @Published var invoices: [Date: [InvoiceModel]]
    @Published var dateStart: Date
    @Published var dateEnd: Date?
    @Published var repeated: Repeated
    @Published var repeatedUint: Int = 1
    @Published var monthCost: [String: Decimal]
    
    init(name nm: String,
         budget bdgt: Decimal,
         color cardColor: CardColor = .orange,
         dateStart start: Date = Date.now,
         dateEnd end: Date? = nil,
         repeate re: Repeated = .forever,
         invoices invs: [Date: [InvoiceModel]] = [:])
    {
        id = UUID()
        name = nm
        budget = bdgt
        color = cardColor
        dateStart = start
        dateEnd = re.DateOffset(date: start) ?? end
        repeated = re
        invoices = invs
        cost = 0
        monthCost = [:]
        
        invs.forEach { _, arr in
            arr.forEach { inv in
                cost += inv.cost
                let month = inv.date.MonthKey()
                if let exite = monthCost[month] {
                    monthCost[month] = exite + inv.cost
                } else {
                    monthCost[month] = inv.cost
                }
            }
        }
    }
    
    func AddInvoice(_ invoice: InvoiceModel) {
        let date = invoice.date.DayKey()
        let month = invoice.date.MonthKey()
        if invoices[date] == nil {
            invoices[date] = []
        }
        withAnimation(Config.deafult) {
            invoices[date]!.append(invoice)
            cost += invoice.cost
        }
        
        if monthCost[month] == nil {
            monthCost[month] = 0
        }
        
        withAnimation(Config.deafult) {
            monthCost[month]! += invoice.cost
        }
    }
    
    func RemoveInvoice(_ invoice: InvoiceModel) {
        let date = invoice.date.DayKey()
        let month = invoice.date.MonthKey()
        if invoices[date] == nil {
            return
        }
        
        if let index = invoices[date]?.firstIndex(where: { $0.id == invoice.id }) {
            withAnimation(Config.deafult) {
                let removed = invoices[date]!.remove(at: index)
                cost -= removed.cost
                monthCost[month]! -= removed.cost
            }
        }
    }
    
    func EditInvoice(old: InvoiceModel, new: InvoiceModel) {
        RemoveInvoice(old)
        AddInvoice(new)
    }
}
