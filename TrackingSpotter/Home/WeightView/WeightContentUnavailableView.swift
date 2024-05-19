import SwiftUI

struct WeightContentUnavailableView: View {
    let action : () -> Void
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("weight_content_unavailable_title", systemImage: "scalemass")
        }, description: {
            Text("weight_content_unavailable_description")
        }, actions: {
            Button {
                action()                
            } label: {
                Text("weight_content_unavailable_button_title")
            }
        })
        .dynamicTypeSize(.xSmall ... .xLarge) // This helps ensure that the icon displays
    }
}
