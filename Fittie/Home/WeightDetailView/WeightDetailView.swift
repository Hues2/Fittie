import SwiftUI
import SwiftData

struct WeightDetailView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = WeightDetailViewModel()
    @Query(sort: \Weight.date) private var loggedWeights: [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var expandedCellId : PersistentIdentifier?
    @State private var weightToBeEdited : Weight?
    
    var body: some View {
        content
            .sheet(isPresented: $isAddingWeight) {
                LogWeightView()
                    .withCustomSheetHeight()
            }
            .sheet(item: $weightToBeEdited) { weight in
                UpdateWeightView(weightToBeEdited: weight)
                    .withCustomSheetHeight()
            }
            .toolbarBackground(Material.thick, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: Content
private extension WeightDetailView {
    var content: some View {
        VStack(spacing: 0) {
            infoHeader
            ScrollView(.vertical) {
                VStack(spacing: 12) {
                    chart
                        .padding()
                    loggedWeightsList
                        .padding()
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: Info Header
private extension WeightDetailView {
    var infoHeader : some View {
        HStack {
            // Current weight
            infoTextView(NSLocalizedString("weight_detail_view_start_weight", comment: "Start"),
                         loggedWeights.first?.kg)
            infoTextView(NSLocalizedString("weight_detail_view_current_weight", comment: "Current"),
                         loggedWeights.last?.kg)
            weightChangeView
        }
        .padding()
        .background(Material.thick)
        .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
    }
    
    func infoTextView(_ title : String, _ value : Double?) -> some View {
        VStack {
            Text("\(value?.toTwoDecimalPlacesString() ?? "-")")
                .font(.title2)
                .fontWeight(.semibold)
            Text(title +
                 " (\(NSLocalizedString("log_weight_kg_label", comment: "Kg unit")))")
            .font(.caption)
            .fontWeight(.light)
            .foregroundStyle(.secondary)
        }
        .lineLimit(1)
        .minimumScaleFactor(Constants.minimumScaleFactor)
        .frame(maxWidth: .infinity)
    }
    
    var weightChangeView : some View {
        VStack {
            Text("\(getWeightChange()?.toTwoDecimalPlacesString() ?? "-")")
                .font(.title2)
                .fontWeight(.semibold)
            Text(NSLocalizedString("weight_detail_view_change", comment: "Change") + "(\(getWeightChangePercentage()?.toTwoDecimalPlacesString() ?? "-") %)")
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
        }
        .lineLimit(1)
        .minimumScaleFactor(Constants.minimumScaleFactor)
        .frame(maxWidth: .infinity)
    }
    
    func getWeightChange() -> Double? {
        guard let startWeight = loggedWeights.first?.kg, let currentWeight = loggedWeights.last?.kg else { return nil }
        return currentWeight - startWeight
    }
    
    func getWeightChangePercentage() -> Double? {
        guard let startWeight = loggedWeights.first?.kg, let currentWeight = loggedWeights.last?.kg else { return nil }
        let weightChange = currentWeight - startWeight
        let percentageChange = (weightChange / startWeight) * 100
        return percentageChange
    }
}

// MARK: Chart
private extension WeightDetailView {
    var chart: some View {
        VStack(spacing: 16) {
            chartView
                .frame(height: Constants.graphCardHeight)
        }        
        //        .background(Material.thick)
        //        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    var chartView: some View {
        WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $viewModel.weightGoal, showAverage: false)
    }
}

// MARK: List content
private extension WeightDetailView {
    var loggedWeightsHeader : some View {
        HStack {
            Text("weight_detail_view_logged_weights")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                withAnimation {
                    self.isAddingWeight = true
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundStyle(.accent.gradient)
                    .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    var loggedWeightsList : some View {
        VStack {
            loggedWeightsHeader
            loggedWeightsCells
        }
    }
    
    var loggedWeightsCells: some View {
        LazyVStack {
            ForEach(loggedWeights.reversed()) { loggedWeight in
                LoggedWeightCell(date: loggedWeight.date,
                                 kg: loggedWeight.kg,
                                 isExpanded: (self.expandedCellId == loggedWeight.id),
                                 deleteAction: { self.deleteAction(loggedWeight) },
                                 editAction: { self.editAction(loggedWeight) })
                .onTapGesture {
                    cellOnTap(loggedWeight.id)
                }
            }
        }
    }
}

// MARK: Functionality
private extension WeightDetailView {
    func cellOnTap(_ id : PersistentIdentifier) {
        withAnimation(.smooth) {
            if expandedCellId == id {
                self.expandedCellId = nil
            } else {
                self.expandedCellId = id
            }
        }
    }
    
    func editAction(_ weight : Weight) {
        withAnimation(.smooth) {
            self.weightToBeEdited = weight
        }
    }
    
    func deleteAction(_ weight : Weight) {
        withAnimation(.smooth) {
            context.delete(weight)
        }
    }
}

#Preview {
    NavigationStack {
        WeightDetailView()
    }
}
