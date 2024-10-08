import SwiftUI

struct CustomSheetHeight : ViewModifier {
    @State private var detentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(Constants.dynamicTypeSizeRange)
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
