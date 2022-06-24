import SwiftUI

struct BudgetOrderView: View {
    @EnvironmentObject var content: ContentViewModel
    @State var editMode: EditMode = .active
    var body: some View {
        VStack(spacing: 1) {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(Config.deafult) {
                            content.showBudgetOrderer = false
                            content.showSetting = true
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    })
                    Spacer()
                    Text("調整卡片順序")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.theme.primary)
                    Spacer()
                }.padding()

                ListView()
                    .environmentObject(content)
                    .environment(\.editMode, self.$editMode)
            }
            .foregroundColor(.theme.primary)
            .background(Color.theme.background.opacity(0.9))
        }
        .foregroundColor(.theme.primary)
        .clipShape(RoundedRectangle(cornerRadius: Config.cornerRadius))
        .padding()
    }
}

struct ListView: View {
    @EnvironmentObject var content: ContentViewModel

    var body: some View {
        List {
            ForEach(content.budgets) { budget in
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
            .onMove(perform: move)
        }
        .foregroundColor(.theme.primary)
        .frame(maxHeight: 500)
        .listStyle(.plain)
        .background(Color.clear)
        .padding(.horizontal)
    }

    func move(from source: IndexSet, to destination: Int) {
        content.budgets.move(fromOffsets: source, toOffset: destination)
    }
}
