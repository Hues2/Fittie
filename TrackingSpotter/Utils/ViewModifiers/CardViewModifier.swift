import SwiftUI

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.darkGray)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

extension View {
    func withCardModifier() -> some View {
        self.modifier(CardViewModifier())
    }
}
