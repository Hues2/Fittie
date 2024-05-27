import SwiftUI
import SwiftData
import Charts

// MARK: Used for the home view weight cahrt card
struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights : [Weight]
    @State private var isAddingWeight : Bool = false    
    @Binding var weightGoal : Double?
    
    var body: some View {
        CardView(icon: "scalemass.fill", title: "weight_title", height: Constants.graphCardHeight - 25) {
            chartView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            arrowIcon
                .padding()
        }
        .sheet(isPresented: $isAddingWeight) {
            LogWeightView()
                .withCustomSheetHeight()
        }
    }
}

// MARK: Add/Update Weight
private extension WeightView {
    var arrowIcon : some View {
        Image(systemName: "arrow.forward")
            .foregroundStyle(Color.accentColor)
    }
}

// MARK: Line Chart
private extension WeightView {
    var chartView : some View {
        WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $weightGoal) {
            withAnimation {
                isAddingWeight = true
            }
        }
    }
}
