import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights : [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var weightToUpdate : Weight?
    @Binding var weightGoal : Double?
    @Binding var isWeightDetailView : Bool
    
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
        .onTapGesture {
            withAnimation {
                self.isWeightDetailView.toggle()
            }
        }
        .overlay(alignment: .topTrailing) {
            navigationButton
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
    var navigationButton : some View {
        Button {
            
        } label: {
            Image(systemName: isWeightDetailView ? "xmark" : "arrow.forward")
        }
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
