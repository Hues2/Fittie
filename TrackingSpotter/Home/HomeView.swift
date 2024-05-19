import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        content
            .navigationTitle("home_nav_title")
            .onAppear {
                viewModel.getDailySteps()
            }
    }
}

// MARK: - Home View Content
private extension HomeView {
    var content : some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                firstSection
                secondSection
                thirdSection
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Row Sections
private extension HomeView {
    var firstSection : some View {
        HStack {
            dailyStepCountView
            stepGoal
        }
    }
    
    var secondSection : some View {
        averageStepsView
    }
    
    var thirdSection : some View {
        weightView
    }
}

// MARK: - Daily Steps
private extension HomeView {
    @ViewBuilder var dailyStepCountView : some View {
        DailyStepCountView(steps: viewModel.todaysSteps,
                           isLoading: viewModel.dailyStepsAreLoading)
    }
}

// MARK: - Achieved Step Goals View
private extension HomeView {
    var stepGoal : some View {
        StepGoalView(stepGoal: viewModel.stepGoal,
                     achievedStepGoals: viewModel.achievedStepGoals,
                     isLoading: viewModel.achievedStepGoalsIsLoading)
    }
}

// MARK: - Average Steps
private extension HomeView {
    @ViewBuilder var averageStepsView : some View {
        AverageStepsView(steps: $viewModel.chartSteps,
                         stepGoal: $viewModel.stepGoal,
                         isLoading: viewModel.stepsAreLoading,
                         selectedPeriod: $viewModel.selectedPeriod)
    }
}

// MARK: - Weight Section
private extension HomeView {
    var weightView : some View {
        WeightView()
            .padding(.bottom, 12)
    }
}

#Preview {
    HomeView()
}
