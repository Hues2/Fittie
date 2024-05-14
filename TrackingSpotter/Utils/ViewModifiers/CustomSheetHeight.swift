import SwiftUI

struct CustomSheetHeight : ViewModifier {
    @State private var detentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 32)
            .padding(.bottom, 8)
            .presentationCornerRadius(Constants.sheetCornerRadius)
            .readHeight()
            .onPreferenceChange(HeightPreferenceKey.self) { height in
                if let height {
                    self.detentHeight = height
                }
            }
            .presentationDetents([.height(self.detentHeight)])
            .presentationDragIndicator(.visible)
    }
}

extension View {
    func withCustomSheetHeight() -> some View {
        modifier(CustomSheetHeight())
    }
}
