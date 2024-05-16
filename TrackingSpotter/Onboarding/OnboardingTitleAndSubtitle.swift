import SwiftUI

struct OnboardingTitleAndSubtitle: View {
    let title : LocalizedStringKey
    let subtitle : LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text(title)
                .foregroundStyle(Color.customText)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(subtitle)
                .foregroundStyle(Color.customText)
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineSpacing(Constants.lineSpacing)
        }
    }
}
