import SwiftUI

struct ActivityPermissionsView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            title
            subtitle
            icon
                .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
}

private extension ActivityPermissionsView {
    var title : some View {
        Text("onboarding_request_auth_title")
            .foregroundStyle(Color.customText)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    var subtitle : some View {
        Text("onboarding_request_auth_subtitle")
            .foregroundStyle(Color.customText)
            .font(.headline)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .lineSpacing(Constants.lineSpacing)
    }
    
    var icon : some View {
        Image(systemName: "figure.walk")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 250)
            .foregroundStyle(Color.accentColor)
    }
}

#Preview {
    ActivityPermissionsView()
        .background(Material.regular)
}
