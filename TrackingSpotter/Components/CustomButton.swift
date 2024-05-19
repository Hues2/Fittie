import SwiftUI

struct CustomButton: View {
    let title : LocalizedStringKey
    let action : () -> Void
    let backgroundColor : Color = Color.accentColor
    let foregroundColor : Color = Color.white
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(foregroundColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
