//
//  SwiftUIView.swift
//
//
//  Created by Yanun on 2022/6/5.
//

import SwiftUI

struct ArchivedBudgetsView: View {
    @EnvironmentObject var content: ContentViewModel
    var body: some View {
        VStack(spacing: 1) {
            VStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 50)
                HStack {
                    Button(action: {
                        withAnimation(Config.deafult) {
                            content.showArchivedBudgets = false
                            content.showSetting = true
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    })
                    Spacer()
                    Text("已過期卡片")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.theme.primary)
                    Spacer()

                }.padding()

                if content.archivedBudgets.isEmpty {
                    Text("沒有任何過期卡片")
                        .font(.title3)
                        .foregroundColor(.theme.secondary)
                        .padding()
                } else {
                    ArchivedListView()
                }

                Spacer()
            }
            .foregroundColor(.theme.primary)
            .background(Color.theme.background.opacity(0.9))
        }
        .foregroundColor(.theme.primary)
    }
}

struct ArchivedBudgetsView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedBudgetsView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
        ArchivedListView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}

struct ArchivedListView: View {
    @EnvironmentObject var content: ContentViewModel

    var body: some View {
        List {
            ForEach(Array(content.archivedBudgets.keys.enumerated()).sorted {
                $0.element > $1.element
            }, id: \.element) { _, date in
                if let budget = content.archivedBudgets[date] {
                    HStack {
                        Spacer()
                        Text(budget.name)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .font(.title3)
                    .foregroundColor(.theme.background)
                    .frame(height: 40)
                    .listRowBackground(budget.color.render)
                    .listRowSeparatorTint(Color.clear)
                }
            }
        }
        .foregroundColor(.theme.primary)
        .listStyle(.plain)
        .background(Color.clear)
        .padding(.horizontal)
    }
}
