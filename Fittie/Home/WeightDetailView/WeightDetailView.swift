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
                .toolbar(.hidden)
                    
                Color.clear
                .background(Material.ultraThickMaterial)
                .frame(height: safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            
        }
        .minimumScaleFactor(Constants.minimumScaleFactor)
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
        VStack(spacing: 36) {
            navigationBar
            
            HStack {
                // Start weight
                infoTextView(NSLocalizedString("weight_detail_view_start_weight", comment: "Start"),
                             loggedWeights.first?.kg)
                // Current weight
                infoTextView(NSLocalizedString("weight_detail_view_current_weight", comment: "Current"),
                             loggedWeights.last?.kg)
                // Weight change
                weightChangeView
            }
        }
        .padding()
        .background(Material.ultraThickMaterial)
        .cornerRadius(Constants.sheetCornerRadius, corners: [.bottomLeft, .bottomRight])
    }
    
    var navigationBar : some View {
        Text("weight_detail_view_title")
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(12)
                        .contentShape(Circle())
                }
                .buttonStyle(BackButtonStyle())
            }
            .font(.title2)
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
        .frame(maxWidth: .infinity)
    }
    
    var weightChangeView : some View {
        VStack {
            HStack {
                if let weightChange = getWeightChange(),
                   let currentWeight = loggedWeights.last?.kg,
                   let weightGoal = viewModel.weightGoal {
                    Image(systemName: weightChange < 0 ? "arrow.down.right" : "arrow.up.right")
                        .foregroundStyle(imageColor(weightGoal, currentWeight, weightChange))
                }
                Text("\(getWeightChange()?.toTwoDecimalPlacesString() ?? "-")")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            Text(NSLocalizedString("weight_detail_view_change", comment: "Change") + "(\(getWeightChangePercentage()?.toTwoDecimalPlacesString() ?? "-") %)")
                .font(.caption)
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
    
    func getWeightChangePercentage() -> Double? {
        guard let startWeight = loggedWeights.first?.kg, let currentWeight = loggedWeights.last?.kg else { return nil }
        let weightChange = currentWeight - startWeight
        let percentageChange = (weightChange / startWeight) * 100
        return percentageChange
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
        chartView
            .frame(height: Constants.graphCardHeight)
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
