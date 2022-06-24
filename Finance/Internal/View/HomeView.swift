import SwiftUI

struct HomeView: View {
    @EnvironmentObject var content: ContentViewModel
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HeaderView()
                        .environmentObject(content)
                        .padding(.horizontal)
                }
                .frame(height: 70)
                
                ZStack {
                    if !content.isBudgetsEmpty {
                        if !content.stack {
                            SlideView()
                                .environmentObject(content)
                        }
                        VStack {
                            Spacer()
                            Button(action: {
                                if content.isCoverd { return }
                                withAnimation(Config.slide) {
                                    content.showAdder = true
                                }
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(content.currentColor)
                                    .padding()
                                    .background(
                                        Circle()
                                            .foregroundColor(.theme.background)
                                            .shadow(color: .theme.shadow,
                                                    radius: Config.shadowRadius,
                                                    x: 0, y: 0)
                                    )
                            })
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
                
                if content.isBudgetsEmpty {}
                
            }.padding(.bottom).zIndex(0).blur(radius: content.isCoverd ? Config.coverBlur : 0)
            
            if content.isCoverd {
                CoverView(action: {
                    if content.isKeyboardShown || content.isDatePickerShown {
                        content.isDatePickerShown = false
                        UIApplication.shared.DismissKeyboard()
                        return
                    }
                    content.Dismiss()
                }).edgesIgnoringSafeArea(.all).zIndex(1)
            }
            
            ZStack {
                if content.showBudgetContext {
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 55)
                        GeometryReader { outer in
                            VStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: content.isFold ? outer.size.width*0.4 : 0)
                                BudgetView(budget: content.currentBudget, hideBudgetTime: $content.hideBudgetTime)
                                    .environmentObject(content)
                                    .transition(.asymmetric(
                                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                                        removal: .scale(scale: 0.97).combined(with: .opacity)
                                    ))
                                    .frame(height: outer.size.width*0.63)
                                    .disabled(true)
                                    .onTapGesture {
                                        content.Dismiss()
                                    }
                                BudgetContextView()
                                    .environmentObject(content)
                                    .transition(.scale(scale: 0.3, anchor: .topLeading)
                                        .combined(with: .opacity))
                            }.padding(.horizontal)
                        }.edgesIgnoringSafeArea(.all)
                    }
                }
            }.zIndex(2)
            
            ZStack {
                if content.showBudgetEditer {
                    BudgetEditerView()
                        .environmentObject(content)
                        .transition(.opacity)
                }
                
                if content.showBudgetDeleter {
                    BudgetDeleteView()
                        .environmentObject(content)
                        .transition(.opacity)
                }
                
                if content.showArchived {
                    ArchivedView()
                        .environmentObject(content)
                        .transition(.opacity)
                }
                
                if content.showSetting {
                    SettingView()
                        .environmentObject(content)
                        .transition(.move(edge: .leading))
                }
                
                if content.showCreater {
                    CreaterView()
                        .environmentObject(content)
                        .transition(.scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity))
                }
                
                if content.showInvoiceEditer && content.currentInvoice.cost != 0 {
                    InvoiceEditerView()
                        .environmentObject(content)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                if content.showAdder {
                    AdderView()
                        .environmentObject(content)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                if content.showBudgetOrderer {
                    BudgetOrderView()
                        .environmentObject(content)
                        .transition(.move(edge: .trailing))
                }
                
                if content.showArchivedBudgets {
                    ArchivedBudgetsView()
                        .environmentObject(content)
                        .transition(.move(edge: .trailing))
                }
            }
            .zIndex(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            // Write code for keyboard opened.
            content.isKeyboardShown = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            // Write code for keyboard closed.
            content.isKeyboardShown = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentViewModel())
    }
}

struct BudgetContextView: View {
    @EnvironmentObject var content: ContentViewModel
    private var rectcolor: Color = .white.opacity(0.7)
    var body: some View {
        HStack {
            VStack {
                Button(role: .cancel, action: {
                    withAnimation(Config.deafult) {
                        content.showBudgetContext = false
                        content.showBudgetEditer = true
                    }
                }) {
                    Label {
                        Text("編輯卡片")
                    } icon: {
                        Image(systemName: "square.and.pencil")
                    }
                    .foregroundColor(.black)
                    .font(.body)
                }
                .padding(.all, 10)
                .padding(.horizontal, 50)
                .background(
                    RoundedRectangle(cornerRadius: Config.buttonRadius)
                        .foregroundColor(rectcolor)
                )
                
                if content.currentBudget.dateEnd != nil {
                    Button(action: {
                        withAnimation(Config.deafult) {
                            content.showBudgetContext = false
                            content.showArchived = true
                        }
                    }) {
                        Label {
                            Text("封存卡片")
                        } icon: {
                            Image(systemName: "archivebox")
                        }
                        .font(.body)
                        .foregroundColor(content.currentColor)
                    }
                    .padding(.all, 10)
                    .padding(.horizontal, 50)
                    .background(
                        RoundedRectangle(cornerRadius: Config.buttonRadius)
                            .foregroundColor(rectcolor)
                    )
                }
                
                Button(role: .destructive, action: {
                    withAnimation(Config.deafult) {
                        content.showBudgetContext = false
                        content.showBudgetDeleter = true
                    }
                }) {
                    Label {
                        Text("刪除卡片")
                    } icon: {
                        Image(systemName: "trash")
                    }
                    .font(.body)
                }
                .padding(.all, 10)
                .padding(.horizontal, 50)
                .background(
                    RoundedRectangle(cornerRadius: Config.buttonRadius)
                        .foregroundColor(rectcolor)
                )
            }
            
            Spacer()
        }
    }
}
