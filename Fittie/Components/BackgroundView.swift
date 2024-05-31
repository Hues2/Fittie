import SwiftUI

struct BackgroundView: View {
    var body: some View {
//        LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.background, Color.background]),
//                       startPoint: .topLeading,
//                       endPoint: .bottomTrailing)
//            .blur(radius: 24)
        Color.background
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundView()
}
