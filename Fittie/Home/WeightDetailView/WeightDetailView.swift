import SwiftUI
import SwiftData

struct WeightDetailView: View {
    @StateObject private var viewModel = WeightDetailViewModel()
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights: [Weight]
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    private let material : Material = .ultraThickMaterial
    
    var body: some View {
        content
    }
}

// MARK: Content
private extension WeightDetailView {
    var content: some View {
        VStack {
            header
            list
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("weight_detail_view")
        .toolbarBackground(material, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: Header
private extension WeightDetailView {
    var header: some View {
        VStack(spacing: 16) {
            chartView
                .frame(height: Constants.graphCardHeight - 10)
        }
        .padding()
        .background(material)
        .cornerRadius(Constants.headerCornerRadius, corners: [.bottomLeft, .bottomRight])
    }
    
    var chartView: some View {
        WeightChartView(loggedWeights: self.loggedWeights, weightGoal: $viewModel.weightGoal)
    }
}

// MARK: List content
private extension WeightDetailView {
    var list: some View {
        VStack {
            Text("LOGGED WEIGHTS LIST")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        WeightDetailView()
    }
}
