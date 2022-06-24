import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var content: ContentViewModel

    var body: some View {
        HStack {
            Button(action: {
                withAnimation(Config.slide) {
                    content.showSetting = true
                }
            }, label: {
                Image(systemName: "text.justify")

            }).disabled(content.isCoverd)

            Spacer()

            VStack {
                Text(Date.now.String(format: "YYYY / MM / dd"))
                    .font(.system(.title3, design: .rounded))
                Text(Date.now.String(format: "EEEE"))
                    .font(.system(.caption, design: .rounded))
            }

            Spacer()

            Button(action: {
                withAnimation(Config.slide) {
                    content.showCreater = true
                }
            }, label: {
                Image(systemName: "rectangle.center.inset.filled.badge.plus")
                    .foregroundColor(.theme.secondary)
            }).disabled(content.isCoverd)
        }
        .font(.system(.title, design: .rounded))
        .foregroundColor(.theme.secondary)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(ContentViewModel())
            .previewLayout(.sizeThatFits)
    }
}
