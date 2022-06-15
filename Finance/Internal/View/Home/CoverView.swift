import SwiftUI

struct CoverView: View {
    let action: ()-> Void
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.theme.shadow)
            .onTapGesture {
                withAnimation(.easeInOut(duration: Config.opacitySpeed)){
                    action()
                }
            }
            .transition(.opacity)
    }
}
