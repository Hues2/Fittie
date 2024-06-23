import SwiftUI

struct CustomButton: View {
    let title : LocalizedStringKey
    var backgroundColor : Color = Color.accentColor
    var foregroundColor : Color = Color.white
    let action : () -> Void
    
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
                .compositingGroup()
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
