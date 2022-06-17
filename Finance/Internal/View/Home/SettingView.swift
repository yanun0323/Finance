import SwiftUI

struct SettingView: View {
    @EnvironmentObject var content: ContentViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("設定")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        withAnimation(Config.deafult){
                            content.Dismiss()
                        }
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.title)
                    })
                }.padding().padding(.bottom)
                
                
                
                Toggle(isOn: $content.hideBudgetTime, label: {
                    Text("隱藏卡片日期")
                        .font(.title3)
                        .fontWeight(.medium)
                }).padding()
                
                Button(action: {
                    withAnimation(Config.deafult){
                        content.showSetting = false
                        content.showBudgetOrderer = true
                    }
                }, label: {
                    HStack {
                        Text("調整卡片順序")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(content.currentColor)
                    }
                })
                .padding()
                
                Button(action: {
                    withAnimation(Config.deafult){
                        content.showSetting = false
                        content.showArchivedBudgets = true
                    }
                }, label: {
                    HStack {
                        Text("已過期卡片")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(content.currentColor)
                    }
                })
                .padding()
                
                VStack(alignment: .leading) {
                    Text("TODO")
                        .font(.title2)
                        .padding(.bottom)
                    Text("卡片重複 追加多週 or 多月份")
                    Text("到期卡片自動轉移")
                    Text("月支出歷史統計頁面")
                    Text("自訂提醒功能")
                    Text("資料庫")
                }.padding()
                
                Spacer()
                
            }
            .foregroundColor(.theme.primary)
            .frame(width: 250)
            .background(Color.theme.background.opacity(0.9))
            .lineLimit(1)
            .padding(.trailing)
            
            Spacer()
        }
    }
    
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}
