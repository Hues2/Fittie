import SwiftUI
import SwiftData
import Charts

struct WeightView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights : [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var weightToUpdate : Weight?
    
    var body: some View {
        CardView(title: "weight_title", height: Constants.graphCardHeight - 25) {
            VStack {
                if loggedWeights.isEmpty {
                    contentUnavailable
                } else if loggedWeights.count == 1, let loggedWeight = loggedWeights.first {
                    loggedWeightView(loggedWeight)
                } else {
                    chartView
                }
                deleteButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(isPresented: $isAddingWeight) {
            LogWeightView()
                .withCustomSheetHeight()
        }
        .sheet(item: $weightToUpdate) { weight in
            UpdateWeightView(todaysWeight: weight)
                .withCustomSheetHeight()
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
    var button : some View {
        Button {
            if userHasAddedWeightToday() {
                // Show update weight sheet
                guard let todaysWeight = loggedWeights.last else { return }
                self.weightToUpdate =  todaysWeight
            } else {
                // Show log weight sheet
                self.isAddingWeight = true
            }
        } label: {
            Text(userHasAddedWeightToday() ? "weight_update_button_title" : "weight_log_button_title")
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
        VStack {
            lineChart
            button
        }
    }
    
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

// MARK: 1 Logged Weight
private extension WeightView {
    func loggedWeightView(_ loggedWeight : Weight) -> some View {
        VStack {
            LoggedWeightView(loggedWeight: loggedWeight)
            button
        }
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
                self.isAddingWeight = true
            } label: {
                Text("weight_content_unavailable_button_title")
            }
        })
        .dynamicTypeSize(.xSmall ... .xLarge) // This helps ensure that the icon displays
    }
}
