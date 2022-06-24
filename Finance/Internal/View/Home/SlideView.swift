import SwiftUI

struct SlideView: View {
    @EnvironmentObject var content: ContentViewModel
    @GestureState private var offset: CGFloat = .zero
    @GestureState private var longPressing: Bool = false
    @State private var start: CGFloat = .zero
    @State private var width: CGFloat = .zero
    @State private var longPressed: Bool = false
    private let impactMed = UIImpactFeedbackGenerator(style: .rigid)
    
    private let threshold: CGFloat = 0.1
    private let decay: CGFloat = 3
    
    var mDistance: CGFloat {
        CGFloat(content.budgetIndex)*width
    }
    
    var mX: CGFloat {
        start + offset - mDistance
    }
    
    var body: some View {
        GeometryReader { outer in
            VStack(alignment: .leading, spacing: 0) {
                if content.isFold {
                    PieTotalView()
                        .environmentObject(content)
                        .padding([.bottom, .horizontal])
                        .frame(height: outer.size.width*0.4)
                        .transition(.scale(scale: 0.2, anchor: .top).combined(with: .move(edge: .bottom)))
                }
                HStack(spacing: 0) {
                    ForEach(content.budgets) { budget in
                        BudgetView(budget: budget, hideBudgetTime: $content.hideBudgetTime)
                            .environmentObject(content)
                            .scaleEffect(content.currentBudget.id == budget.id && longPressed ? 0.95 : 1)
                            .scaleEffect(content.currentBudget.id == budget.id && content.showBudgetContext ? 1.02 : 1)
                            .onLongPressGesture(minimumDuration: 0.4) { value in
                                withAnimation(.interpolatingSpring(mass: 0.5, stiffness: 100, damping: 1000, initialVelocity: 0)) {
                                    longPressed = value
                                }
                            } perform: {
                                withAnimation(Config.slide) {
                                    longPressed = false
                                    content.showBudgetContext = true
                                }
                                impactMed.impactOccurred()
                            }
                            .padding(.horizontal, content.currentBudget.id == budget.id ? 20 : -10)
                    }
                }
                .frame(width: outer.size.width*CGFloat(content.budgets.count),
                       height: outer.size.width*0.6)
                .offset(x: mX)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { value, state, _ in
                            if OutOfBounds(value.translation.width) {
                                state = value.translation.width / decay
                                return
                            }

                            state = value.translation.width
                        })
                        .onEnded { value in
                            if value.translation.width == 0 { return }
                            let step: Int = value.translation.width > 0 ? -1 : 1
                            var next = content.budgetIndex + step
                            var moving = value.translation.width

                            if InThreshold(outer.size.width, value.translation.width) {
                                next = content.budgetIndex
                            }

                            if OutOfBounds(next) {
                                next = content.budgetIndex
                                moving = moving / decay
                            }

                            start = moving
                            withAnimation(Config.slide) {
                                content.budgetIndex = next
                                start = 0
                            }
                        }
                )
                
                HStack {
                    Spacer()
                    ForEach(content.budgets) { budget in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(maxWidth: 50, maxHeight: 50)
                            RoundedRectangle(cornerRadius: Config.buttonRadius)
                                .frame(maxWidth: 20, maxHeight: 12)
                                .scaleEffect(x: budget.id == content.currentBudget.id ? 1 : 0, y: 1, anchor: .center)
                            Image(systemName: "circle.fill")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(budget.color.render)
                        .onTapGesture {
                            withAnimation(Config.deafult) {
                                content.budgetIndex = content.IndexOf(budget: budget)
                            }
                        }
                    }
                    Spacer()
                }
                .background(Color.theme.background)
                
                HStack {
                    ForEach(content.budgets) { budget in
                        InvoiceView(content: content, budget: budget)
                    }
                }
                .offset(x: mX)
                .frame(width: outer.size.width*CGFloat(content.budgets.count))
                .onAppear {
                    width = outer.size.width
                }
            }
        }
    }
    
    private func InThreshold(_ width: CGFloat, _ drag: CGFloat) -> Bool {
        return abs(drag) < width*threshold
    }
    
    private func OutOfBounds(_ drag: CGFloat) -> Bool {
        return (content.budgetIndex == 0 && drag > 0) ||
            (content.budgetIndex == content.budgets.count - 1 && drag < 0)
    }
    
    private func OutOfBounds(_ index: Int) -> Bool {
        return index < 0 || index >= content.budgets.count
    }
}

struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}
