import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.customBackground, Color.customBackground]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .opacity(0.2)
            .blur(radius: 20)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    BackgroundView()
}
