import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var content: ContentViewModel
    @ObservedObject var budget: BudgetModel
    @Binding var hideBudgetTime: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: Config.cornerRadius)
            .foregroundColor(budget.color.render)
            .shadow(color: .theme.shadow,
                    radius: Config.shadowRadius,
                    x: 0, y: 0)
            .overlay {
                CardText(budget: budget, hideBudgetTime: $hideBudgetTime)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.4)) {
                    content.isFold.toggle()
                    content.showBudgetContext = false
                }
            }
    }
}

struct CardText: View {
    @ObservedObject var budget: BudgetModel
    @Binding var hideBudgetTime: Bool
    private let textColor: Color = .theme.background
    private let budgetColor: Color = .theme.background.opacity(0.2)

    var body: some View {
        HStack {
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                HStack {
                    if !hideBudgetTime {
                        VStack(alignment: .trailing, spacing: 0) {
                            Text(budget.dateStart.String(format: "YYYY-MM-dd"))
                                .foregroundColor(textColor)
                                .font(.system(.callout, design: .rounded))
                                .fontWeight(.light)
                            Text(budget.repeated == .forever ? " " : (budget.dateEnd?.String(format: "YYYY-MM-dd") ?? " "))
                                .foregroundColor(textColor)
                                .font(.system(.callout, design: .rounded))
                                .fontWeight(.light)
                        }
                    }
                    Spacer()
                    Text(budget.name)
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .foregroundColor(textColor)
                        .fontWeight(.heavy)
                        .minimumScaleFactor(0.3)
                }
                .truncationMode(.tail)
                Spacer()
                Text((budget.budget - budget.cost).description)
                    .foregroundColor(textColor)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                Text("\(budget.budget.description)")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(budgetColor)
                    .offset(y: -15)
                Spacer()
            }
            .padding(.horizontal)
        }
        .lineLimit(1)
        .padding()
        .monospacedDigit()
        .foregroundColor(budget.color.render)
    }
}
