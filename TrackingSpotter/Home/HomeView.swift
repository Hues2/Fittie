import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack {
                StepCountView(steps: viewModel.steps, stepGoal: $viewModel.stepGoal)
                
                Past7DaysStepsView(dailySteps: viewModel.dailySteps)
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .task {
            await viewModel.requestAuthorization()
            viewModel.getTodaysSteps()
            viewModel.getPast7DaysSteps()
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
