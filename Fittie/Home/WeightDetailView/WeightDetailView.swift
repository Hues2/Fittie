import SwiftUI
import SwiftData

struct WeightDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WeightDetailViewModel()
    @Query(sort: \Weight.date) private var loggedWeights: [Weight]
    @State private var isAddingWeight : Bool = false
    @State private var expandedCell : PersistentIdentifier?
    
    var body: some View {
        content
            .sheet(isPresented: $isAddingWeight) {
                LogWeightView()
                    .withCustomSheetHeight()
            }
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
//        .navigationTitle("weight_detail_view_title")
//        .toolbarBackground(.visible, for: .navigationBar)
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
    var loggedWeightsList : some View {
        VStack {
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
            
            scrollView
        }
    }
    
    var scrollView: some View {
        ScrollView {
            VStack {
                ForEach(loggedWeights.reversed()) { loggedWeight in
                    LoggedWeightCell(date: loggedWeight.date,
                                     kg: loggedWeight.kg,
                                     isExpanded: self.expandedCell == loggedWeight.id)
                    .onTapGesture {
                        withAnimation(.smooth) {
                            if expandedCell == loggedWeight.id {
                                self.expandedCell = nil
                            } else {
                                self.expandedCell = loggedWeight.id
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private func deleteWeight(at indexSet: IndexSet) {
        for index in indexSet {
            withAnimation {
                context.delete(loggedWeights[index])
            }
        }
    }
}

#Preview {
    NavigationStack {
        WeightDetailView()
    }
}
