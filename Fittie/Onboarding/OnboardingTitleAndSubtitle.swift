import SwiftUI

struct OnboardingTitleAndSubtitle: View {
    let title : LocalizedStringKey
    let subtitle : LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text(title)                
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.secondaryAccent)
            
            Text(subtitle)                
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineSpacing(Constants.lineSpacing)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    OnboardingTitleAndSubtitle(title: "Onboarding title", subtitle: "Some sort of very long subtitle")
}
