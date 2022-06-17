//
//  SwiftUIView.swift
//  
//
//  Created by Yanun on 2022/5/16.
//

import SwiftUI

struct PieTotalView: View {
    @EnvironmentObject var content: ContentViewModel
    private let rowHeight: CGFloat = 15
    
    private var thisMonth: String { Date.now.String(format: "YYYYMM") } 
    private var thisMonthCost: Decimal{
        var all: Decimal = 0
        for budget in content.budgets {
            all += budget.monthCost[thisMonth] ?? 0
        }
        return all
    }
    var body: some View {
        GeometryReader{ outer in 
            HStack{
                ZStack{
                    PieView()
                        .environmentObject(content)
                    VStack(spacing: 5){
                        Text("本月支出")
                            .font(.system(.subheadline, design: .rounded))
                        Text("$"+thisMonthCost.description)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .monospacedDigit()
                    }
                    .foregroundColor(.theme.primary)
                }
                .frame(width: outer.size.height)
                
                Rectangle()
                    .foregroundColor(.theme.background)
                    .overlay{
                        ScrollView(.vertical, showsIndicators: false){
                            HStack {
                                VStack(spacing: rowHeight){
                                    ForEach(content.budgets){ budget in 
                                        HStack{
                                            Image(systemName: "circle.fill")
                                                .font(.caption2)
                                                .foregroundColor(budget.color.render)
                                            Text(budget.name)
                                                .foregroundColor(.theme.primary)
                                            Spacer()
                                            Text(budget.monthCost[thisMonth]?.description ?? "0")
                                                .fontWeight(.medium)
                                                .foregroundColor(.theme.primary)
                                        }
                                        .onTapGesture {
                                            withAnimation(Config.deafult){
                                                content.budgetIndex = content.IndexOf(budget: budget)
                                            }
                                        }
                                    }
                                }
                            }
                            .font(.system(.body, design: .rounded))
                            .lineLimit(1)
                            .padding(.horizontal)
                        }
                    }
                
            }
        }
    }
}

struct PieTotalView_Preview: PreviewProvider {
    static var previews: some View {
        PieTotalView()
            .environmentObject(ContentViewModel())
            .frame(height: 150)
            .previewLayout(.sizeThatFits)
        PieView()
            .environmentObject(ContentViewModel())
            .frame(height: 150)
            .previewLayout(.sizeThatFits)
    }
}


struct PieView: View {
    @EnvironmentObject var content: ContentViewModel
    @State private var lastOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var mapOffset: Dictionary<UUID, CGFloat> = [:]
    private let ringWidth: CGFloat = 15
    
    private var thisMonth: String { Date.now.String(format: Date.MonthKeyFormat()) } 
    private var thisMonthCost: Decimal{
        var all: Decimal = 0
        for budget in content.budgets {
            all += budget.monthCost[thisMonth] ?? 0
        }
        return all
    }
    
    var body: some View {
        ZStack {
            ForEach(content.budgets){ budget in
                Circle()
                    .trim(from: getStartPos(budget: budget) , 
                          to: getEndPos(budget: budget))
                    .stroke(budget.color.render, lineWidth: ringWidth)
            }
        }
        .padding(.vertical, 9)
        .clipped()
    }
    
    func getStartPos(budget: BudgetModel) -> CGFloat {
        var sum: Decimal = 0
        for b in content.budgets {
            if b.id == budget.id {
                break
            }
            sum += (b.monthCost[thisMonth] ?? 0) / content.monthCost
        }
        return sum.ToCGFloat
    }
    
    func getEndPos(budget: BudgetModel) -> CGFloat {
        var sum: Decimal = 0
        for b in content.budgets {
            sum += (b.monthCost[thisMonth] ?? 0) / content.monthCost
            if b.id == budget.id {
                break
            }
        }
        return sum.ToCGFloat
    }
}
