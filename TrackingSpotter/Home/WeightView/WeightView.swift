import SwiftUI
import SwiftData

struct WeightView: View {
    @Query private var loggedWeights : [Weight]
    @State private var isShowingSheet : Bool = false
    
    var body: some View {
        CardView(title: "weight_title", height: Constants.graphCardHeight) {
            VStack {
                if loggedWeights.isEmpty {
                    contentUnavailable
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $isShowingSheet) {
            LogWeightView()
                .withCustomSheetHeight()
        }
    }
}

private extension WeightView {
    var contentUnavailable : some View {
        ContentUnavailableView(label: {
            Label("weight_content_unavailable_title", systemImage: "scalemass")
        }, description: {
            Text("weight_content_unavailable_description")
        }, actions: {
            Button {                
                self.isShowingSheet = true
            } label: {
                Text("weight_content_unavailable_button_title")
            }
        })
        .dynamicTypeSize(.xSmall ... .xLarge) // This helps ensure that the icon displays
    }
}

#Preview {
    WeightView()
}
