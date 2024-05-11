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

// MARK: - Home View Content
private extension HomeView {
    var content : some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                title
                HStack {
                    stepCountView
                    
                    dailyStepView
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .clipped()
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

// MARK: - Step Count View
private extension HomeView {
    var stepCountView : some View {
        StepCountView(steps: viewModel.steps,
                      stepGoal: $viewModel.stepGoal,
                      healthKitContentIsAvailable: viewModel.healthKitContentIsAvailable,
                      isLoading: viewModel.stepsIsLoading)
        .frame(height: 250)
    }
}

// MARK: - Daily Steps View
private extension HomeView {
    var dailyStepView : some View {
        DailyStepsView(dailySteps: viewModel.dailySteps,
                       stepGoal: viewModel.stepGoal,
                       healthKitContentIsAvailable: viewModel.healthKitContentIsAvailable,
                       isLoading: viewModel.dailyStepsIsLoading)
        .frame(height: 250)
    }
}
