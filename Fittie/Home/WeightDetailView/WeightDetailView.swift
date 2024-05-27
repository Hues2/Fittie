import SwiftUI
import SwiftData

// MARK: Weight detail view
struct WeightDetailView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = WeightDetailViewModel()
    @Query(sort: \Weight.date, animation: .smooth) private var loggedWeights: [Weight]
    // Sheets
    @State private var isAddingWeight : Bool = false
    @State private var weightToBeEdited : Weight?
    @State private var isUpdatingWeightGoal : Bool = false
    private let spacing : CGFloat = 12
    
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()
                .ignoresSafeArea()
            
            content
                .sheet(isPresented: $isAddingWeight) {
                    LogWeightView()
                        .withCustomSheetHeight()
                }
                .sheet(item: $weightToBeEdited) { weight in
                    UpdateWeightView(weightToBeEdited: weight)
                        .withCustomSheetHeight()
                }
                .sheet(isPresented: $isUpdatingWeightGoal) {
                    UpdateWeightGoal(weightGoal: $viewModel.weightGoal)
                        .withCustomSheetHeight()
                }
        }
        .navigationTitle("weight_detail_view_title")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        self.isUpdatingWeightGoal = true
                    }
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "target")
                        Text("weight_goal_toolbar_title")
                    }
                    .foregroundStyle(.accent)
                }
            }
        }
    }
}

// MARK: Content
private extension WeightDetailView {
    var content: some View {
        ScrollView(.vertical) {
            VStack(spacing: spacing) {
                infoHeader
                chart
                
                if !loggedWeights.isEmpty {
                    loggedWeightsList
                        .padding(.top, 24)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Info Header
private extension WeightDetailView {
    var infoHeader : some View {
        HStack(spacing: spacing) {
            // Start weight
            infoTextView("weight_detail_view_start_weight", loggedWeights.first?.kg)
            
            // Current weight
            infoTextView("weight_detail_view_current_weight", loggedWeights.last?.kg)
            
            // Weight change
            infoTextView("weight_detail_view_change", getWeightChange(), true)
        }
    }
    
    func infoTextView(_ title : LocalizedStringKey, _ value : Double?, _ showIcon : Bool = false) -> some View {
        CardView(icon: nil, title: title, height: Constants.cardHeight - 16) {
            VStack {
                HStack(spacing: 4) {
                    if showIcon,
                       let weightChange = getWeightChange(),
                       let currentWeight = loggedWeights.last?.kg,
                       let weightGoal = viewModel.weightGoal,
                       weightChange != .zero {
                        Image(systemName: weightChange < 0 ? "arrow.down.right" : "arrow.up.right")
                            .foregroundStyle(imageColor(weightGoal, currentWeight, weightChange))
                    }
                    
                    Text("\(value?.toTwoDecimalPlacesString() ?? "-")")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                Text(NSLocalizedString("log_weight_kg_label", comment: "Kg unit"))
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
    }
    
    func getWeightChange() -> Double? {
        guard let startWeight = loggedWeights.first?.kg, let currentWeight = loggedWeights.last?.kg else { return nil }
        return currentWeight - startWeight
    }
    
    func imageColor(_ weightGoal : Double, _ currentWeight : Double, _ weightChange : Double) -> Color {
        if weightGoal < currentWeight && weightChange < 0 {
            return .accent // Goal is to lose weight and weight has decreased
        } else if weightGoal > currentWeight && weightChange > 0 {
            return .accent // Goal is to gain weight and weight has increased
        } else {
            return .pink // Otherwise, use red
        }
    }
}

// MARK: Chart
private extension WeightDetailView {
    var chart: some View {
        CardView(icon: nil, title: "", height: Constants.graphCardHeight) {
            WeightChartView(loggedWeights: self.loggedWeights,
                            weightGoal: $viewModel.weightGoal,
                            showXAxis: false) {
                withAnimation {
                    self.isAddingWeight = true
                }
            }
                .frame(height: Constants.graphCardHeight)
        }
    }
}

// MARK: List content
private extension WeightDetailView {
    var loggedWeightsList : some View {
        VStack {
            loggedWeightsHeader
            loggedWeightsCells
        }
    }
    
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
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .fill(.accent)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    var loggedWeightsCells: some View {
        LazyVStack(spacing: spacing) {
            ForEach(loggedWeights.reversed()) { loggedWeight in
                LoggedWeightCell(date: loggedWeight.date,
                                 kg: loggedWeight.kg,
                                 deleteAction: { self.deleteAction(loggedWeight) },
                                 editAction: { self.editAction(loggedWeight) })
            }
        }
    }
}

// MARK: Functionality
private extension WeightDetailView {
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
