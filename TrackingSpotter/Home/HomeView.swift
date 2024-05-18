import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            backgroundColor
            content
        }        
        .navigationTitle("home_nav_title")
    }
}

// MARK: - Views
private extension HomeView {
    var backgroundColor : some View {
        Color.customBackground
            .ignoresSafeArea()
    }
}

// MARK: - Home View Content
private extension HomeView {
    var content : some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                firstSection
                secondSection
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
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
}

// MARK: - Daily Steps
private extension HomeView {
    @ViewBuilder var dailyStepCountView : some View {
        DailyStepCountView(steps: viewModel.dailySteps,
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
        CardView(title: "average_steps_title", height: 275) {
            if viewModel.timePeriodStepsAreLoading {
                LoadingView()
            } else {
                AverageStepsView(steps: $viewModel.selectedPeriodSteps,
                                 selectedPeriod: $viewModel.selectedPeriod,
                                 stepGoal: $viewModel.stepGoal)
            }
        }
    }
}

#Preview {
    HomeView()
}
