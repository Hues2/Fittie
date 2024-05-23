import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights : [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var weightToUpdate : Weight?
    @Binding var weightGoal : Double?
    
    var body: some View {
        CardView(icon: "scalemass.fill", title: "weight_title", height: Constants.graphCardHeight - 25) {
            VStack {
                if loggedWeights.isEmpty {
                    contentUnavailable
                } else {
                    chartView
                }
//                deleteButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            arrowIcon
                .padding()
        }
    }
    
    @ViewBuilder var deleteButton : some View {
        if let loggedWeight = loggedWeights.last {
            CustomButton(title: "DELETE") {
                context.delete(loggedWeight)
            }
        }
    }
}

// MARK: Add/Update Weight
private extension WeightView {
    var arrowIcon : some View {
        Image(systemName: "arrow.forward")
            .foregroundStyle(Color.accentColor)
    }
    
    func userHasAddedWeightToday() -> Bool {
        guard let latestAddedWeight = loggedWeights.last else { return false }
        return latestAddedWeight.date.isSameDay(as: .now)
    }
}

// MARK: Line Chart
private extension WeightView {
    var chartView : some View {
        WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $weightGoal)
    }
}

// MARK: Content Unavailable
private extension WeightView {
    var contentUnavailable : some View {
        WeightContentUnavailableView {
            self.isAddingWeight = true
        }
    }
}
