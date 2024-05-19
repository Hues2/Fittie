import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights : [Weight]
    @State private var isShowingSheet : Bool = false
    
    var body: some View {
        CardView(title: "weight_title", height: Constants.graphCardHeight) {
            VStack {
                if loggedWeights.isEmpty {
                    contentUnavailable
                } else {
                    // Line Chart
                    lineChart
                    if let weight = loggedWeights.first {                    
                        CustomButton(title: "DELETE") {
                            context.delete(weight)
                        }
                    }
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

// MARK: Line Chart
private extension WeightView {
    var lineChart : some View {
        Chart {
            ForEach(loggedWeights) { loggedWeight in
                LineMark(x: .value("Date", loggedWeight.date),
                         y: .value("Weight", loggedWeight.kg))
            }
        }
        .chartYScale(domain: getMinYValue()...getMaxYValue())
    }
    
    func getMinYValue() -> Double {
        let min = loggedWeights.map({ $0.kg }).min()
        return (min ?? .zero) - 2
    }
    
    func getMaxYValue() -> Double {
        let max = loggedWeights.map({ $0.kg }).max()
        return (max ?? .zero) + 2
    }
}

// MARK: Content Unavailable
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
