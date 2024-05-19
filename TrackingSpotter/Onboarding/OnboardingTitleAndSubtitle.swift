import SwiftUI

struct OnboardingTitleAndSubtitle: View {
    let title : LocalizedStringKey
    let subtitle : LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text(title)                
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(subtitle)                
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineSpacing(Constants.lineSpacing)
        }
    }
}
