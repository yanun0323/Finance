//
//  SwiftUIView.swift
//
//
//  Created by Yanun on 2022/5/10.
//

import SwiftUI

struct ArchivedView: View {
    @EnvironmentObject var content: ContentViewModel
    @State private var Archived = false
    @State private var color = Color.red
    @State private var name = ""
    let gap: CGFloat = 1
    let half: CGFloat = 150

    var body: some View {
        VStack(alignment: .center, spacing: gap) {
            if !content.isBudgetsEmpty {
                VStack(spacing: 10) {
                    Text("確定要封存卡片？")
                        .fontWeight(.medium)
                        .foregroundColor(.theme.primary)
                        .padding()
                    Text("\" \(name) \"")
                        .fontWeight(.medium)
                        .foregroundColor(color)
                        .padding(.bottom)
                }
                .padding()
                .frame(width: half+half+gap)
                .background(Color.theme.background.opacity(0.9))
                HStack(spacing: gap) {
                    Button(action: {
                        content.Dismiss()
                    }, label: {
                        Text("取消")
                            .foregroundColor(.black)
                            .fontWeight(.regular)
                            .padding()
                            .frame(width: half)
                            .background(Color.theme.background.opacity(0.9))
                    })
                    Button(role: .destructive, action: {
                        Archived = true
                        content.ArchiveBudget(budget: content.currentBudget)
                    }, label: {
                        Text("封存")
                            .fontWeight(.regular)
                            .padding()
                            .frame(width: half)
                            .background(Color.theme.background.opacity(0.9))
                    }).disabled(Archived)
                }
            }
        }
        .font(.title3)
        .background(Color.theme.secondary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: Config.cornerRadius))
        .onAppear {
            color = content.currentColor
            name = content.currentBudget.name
        }
    }
}

struct ArchivedView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}
