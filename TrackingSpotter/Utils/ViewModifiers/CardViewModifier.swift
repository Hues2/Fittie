import SwiftUI

struct CardViewModifier: ViewModifier {
    let padding : CGFloat?
    
    func body(content: Content) -> some View {
        content
            .padding(padding ?? 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

extension View {
    func withCardModifier(_ padding : CGFloat? = 8) -> some View {
        self.modifier(CardViewModifier(padding: padding))
    }
}
