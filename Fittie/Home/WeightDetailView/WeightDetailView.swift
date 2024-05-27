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
        ZStack(alignment: .top) {
            Color.background
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
        }
        .navigationTitle("weight_detail_view_title")
    }
}

// MARK: Content
private extension WeightDetailView {
    var content: some View {
        ScrollView(.vertical) {
            VStack {
                infoHeader
                chart
                loggedWeightsList
                    .padding(.top, 24)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Info Header
private extension WeightDetailView {
    var infoHeader : some View {
        HStack {
            // Start weight
            CardView(icon: nil, title: "weight_detail_view_start_weight", height: Constants.cardHeight - 8) {
                infoTextView(loggedWeights.first?.kg)
            }
            
            // Current weight
            CardView(icon: nil, title: "weight_detail_view_current_weight", height: Constants.cardHeight - 8) {
                infoTextView(loggedWeights.last?.kg)
            }
            
            // Weight change
            CardView(icon: nil, title: "weight_detail_view_change", height: Constants.cardHeight - 8) {
                infoTextView(getWeightChange(), true)
            }
        }
    }
    
    func infoTextView(_ value : Double?, _ showIcon : Bool = false) -> some View {
        VStack {
            HStack(spacing: 4) {
                if showIcon,
                   let weightChange = getWeightChange(),
                   let currentWeight = loggedWeights.last?.kg,
                   let weightGoal = viewModel.weightGoal {
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
            return .red // Otherwise, use red
        }
    }
}

// MARK: Chart
private extension WeightDetailView {
    var chart: some View {
        CardView(icon: nil, title: "", height: Constants.graphCardHeight) {
            WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $viewModel.weightGoal)
                .frame(height: Constants.graphCardHeight)
        }
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
                HStack {
                    Text("Add new")
                    Image(systemName: "plus")
                }
                .foregroundStyle(Color.white)
                .font(.subheadline)
                .fontWeight(.regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.sheetCornerRadius))
                .contentShape(RoundedRectangle(cornerRadius: Constants.sheetCornerRadius))
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

private extension WeightDetailView {
    struct BackButtonStyle : ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
                .overlay {
                    Circle()
                        .stroke(Color.accentColor)
                }
        }
    }
}

#Preview {
    NavigationStack {
        WeightDetailView()
    }
}
