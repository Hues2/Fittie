import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            content
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

// MARK: - Steps title
private extension HomeView {
    var content : some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                title
                HStack {
                    StepCountView(steps: viewModel.steps, stepGoal: $viewModel.stepGoal)
                        .frame(height: 250)
                    
                    Past7DaysStepsView(dailySteps: viewModel.dailySteps, stepGoal: viewModel.stepGoal)
                        .frame(height: 250)
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }
}

// MARK: - Steps title
private extension HomeView {
    var title : some View {
        Text("steps_title")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}
