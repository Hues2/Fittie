import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack {
                StepCountView(steps: viewModel.steps, stepTarget: viewModel.stepTarget) {
                    viewModel.setStepTarget()
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .task {
            await viewModel.requestAuthorization()
            viewModel.getTodaysSteps()
        }
    }
}

// MARK: - Background
private extension HomeView {
    var backgroundColor : some View {
        Color.customBlack
            .ignoresSafeArea()
    }
}
