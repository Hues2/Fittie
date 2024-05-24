import SwiftUI
import SwiftData

struct WeightDetailView: View {
    @StateObject private var viewModel = WeightDetailViewModel()
    @Environment(\.modelContext) private var context
    @Query(sort: \Weight.date) private var loggedWeights: [Weight]
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    
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
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

// MARK: Navigation bar
private extension WeightDetailView {
    var navigationBar : some View {
        Text("weight_detail_view")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .leading) {
                backButton
            }
    }
    
    var backButton : some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(Color.accentColor)
                .font(.title)
                .fontWeight(.semibold)
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .buttonStyle(BackButtonStyle())
    }
}

// MARK: Header
private extension WeightDetailView {
    var header: some View {
        VStack(spacing: 32) {
            navigationBar
            chartView
                .frame(height: Constants.graphCardHeight)
        }
        .padding()
        .padding(.top, safeAreaInsets.top)
        .background(Material.regular)
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
    WeightDetailView()
}
