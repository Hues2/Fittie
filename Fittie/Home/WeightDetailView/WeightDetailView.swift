import SwiftUI
import SwiftData

struct WeightDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WeightDetailViewModel()
    @Query(sort: \Weight.date) private var loggedWeights: [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var expandedCellId : PersistentIdentifier?
    @State private var weightToBeEdited : Weight?
    
    var body: some View {
        ScrollView(.vertical) {
            content
                .sheet(isPresented: $isAddingWeight) {
                    LogWeightView()
                        .withCustomSheetHeight()
                }
                .sheet(item: $weightToBeEdited) { weight in
                    UpdateWeightView(weightToBeEdited: weight)
                        .withCustomSheetHeight()
                }
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Content
private extension WeightDetailView {
    var content: some View {
        VStack {
            currentWeight
            chart
            loggedWeightsList
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: Current Weight
private extension WeightDetailView {
    @ViewBuilder var currentWeight : some View {
        if let currentWeight = loggedWeights.last?.kg {
            VStack {
                Text("weight_detail_view_current_weight")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                
                Text("\(currentWeight.toTwoDecimalPlacesString())" + NSLocalizedString("log_weight_kg_label", comment: "Kg unit"))
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: Chart
private extension WeightDetailView {
    var chart: some View {
        VStack(spacing: 16) {
            chartView
                .frame(height: Constants.graphCardHeight)
        }
        .padding()
        .background(Material.thick)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    var chartView: some View {
        WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $viewModel.weightGoal)
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
