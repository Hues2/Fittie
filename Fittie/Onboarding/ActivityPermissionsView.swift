import SwiftUI

struct ActivityPermissionsView: View {
    @State private var animate : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            OnboardingTitleAndSubtitle(title: "onboarding_request_auth_title",
                                       subtitle: "onboarding_request_auth_subtitle")
            icon
                .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7)) {
                self.animate = true
            }
        }
    }
}

private extension ActivityPermissionsView {
    var icon : some View {
        Image(systemName: "figure.walk")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 250)
            .foregroundStyle(Color.accentColor)
            .offset(y: animate ? 0 : -80)
            .scaleEffect(animate ? 1 : 0.7)
    }
}

#Preview {
    ActivityPermissionsView()
        .background(Constants.backgroundMaterial)
}
