import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var editMode = EditMode.inactive
    @Published var isKeyboardShown = false
    @Published var isDatePickerShown = false
    @Published var showBudgetContext = false
    @Published var showBudgetOrderer = false
    @Published var showBudgetEditer = false
    @Published var showBudgetDeleter = false
    @Published var showInvoiceEditer = false
    @Published var showCreater = false
    @Published var showSetting = false
    @Published var showAdder = false
    @Published var showArchivedBudgets = false
    @Published var showArchived = false
    @Published var budgetIndex = 0
    @Published var isFold = true
    @Published var currentInvoice = InvoiceModel(date: Date.now, cost: 0)
    @Published var trigger = true
    
    var monthCost: Decimal {
        let thisMonth: String = Date.now.String(format: "YYYYMM")
        var all: Decimal = 0
        for budget in budgets {
            all += budget.monthCost[thisMonth] ?? 0
        }
        return all
    }
    
    var isBudgetsEmpty: Bool {
        budgets.count == 0
    }
    
    var currentBudget: BudgetModel {
        budgets[budgetIndex]
    }
    
    var currentColor: Color {
        budgets[budgetIndex].color.render
    }
    
    var isCoverd: Bool {
        showBudgetContext || showArchivedBudgets || showBudgetDeleter || showBudgetEditer || showCreater || showBudgetOrderer ||
            showSetting || showAdder || showInvoiceEditer || showArchived
    }
    
    func Dismiss() {
        withAnimation(Config.deafult) {
            showArchivedBudgets = false
            showBudgetContext = false
            showBudgetOrderer = false
            showBudgetDeleter = false
            showInvoiceEditer = false
            showBudgetEditer = false
            showArchived = false
            showCreater = false
            showSetting = false
            showAdder = false
            editMode = .inactive
        }
    }
    
    func IndexOf(budget: BudgetModel) -> Int {
        var index = 0
        for b in budgets {
            if b.id == budget.id {
                return index
            }
            index += 1
        }
        return 0
    }
    
    func RefreshBudget() {
        withAnimation(Config.deafult) {
            budgets = budgets
        }
    }
    
    func ArchiveBudget(budget: BudgetModel) {
        withAnimation(Config.deafult) {
            guard let index = budgets.firstIndex(of: budget) else { return }
            let removed = budgets.remove(at: index)
            archivedBudgets[removed.dateEnd!] = removed
            budgetIndex -= (budgetIndex == 0 ? 0 : 1)
            Dismiss()
        }
    }
    
    // User Custom
    @Published var stack = false
    @Published var hideBudgetTime = false
    
    // User Data
    @Published var archivedBudgets: [Date: BudgetModel] = [:]
    @Published var budgets: [BudgetModel] = [
        BudgetModel(name: "?????????",
                    budget: 15000,
                    color: .cyan,
                    dateStart: Date.now,
                    dateEnd: nil,
                    repeate: .forever,
                    invoices: [Date.now.DayKey(): [
                        InvoiceModel(date: Date.now, cost: 140, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 220, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 110, description: "?????????"),
                        InvoiceModel(date: Date.now, cost: 130, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 60, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 140, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 220, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 110, description: "?????????"),
                        InvoiceModel(date: Date.now, cost: 130, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 60, description: "??????"),
                    ]]),
        BudgetModel(name: "?????????",
                    budget: 3000,
                    color: .purple,
                    dateStart: Date.now,
                    dateEnd: nil,
                    repeate: .forever,
                    invoices: [Date.now.DayKey(): [
                        InvoiceModel(date: Date.now, cost: 15, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 1280, description: "???????????????"),
                        InvoiceModel(date: Date.now, cost: 110, description: "Uber"),
                    ]]),
        BudgetModel(name: "?????????",
                    budget: 3000,
                    color: .black,
                    dateStart: Date.now,
                    dateEnd: nil,
                    repeate: .forever,
                    invoices: [Date.now.DayKey(): [
                        InvoiceModel(date: Date.now, cost: 500, description: "??????"),
                        InvoiceModel(date: Date.now, cost: 330, description: "???"),
                    ]]),
        BudgetModel(name: "?????????",
                    budget: 3000,
                    color: .orange,
                    dateStart: Date.now,
                    dateEnd: nil,
                    repeate: .forever,
                    invoices: [:]),
    ]
}
