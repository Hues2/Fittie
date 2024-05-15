import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var presentDailyStepGoalSheet: Bool = false
    
    var body: some View {
        ZStack {
            backgroundColor
            content
        }
        .task {
            await viewModel.requestAuthorization()
            viewModel.getDailySteps()
            viewModel.getMonthlySteps()
            viewModel.getStreak()
        }
        .sheet(isPresented: $presentDailyStepGoalSheet, content: {
            UpdateStepTargetView(stepGoal: $viewModel.dailyStepGoal)
                .withCustomSheetHeight()
        })
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
            VStack(alignment: .leading, spacing: 16) {
                firstSection
                secondSection
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .clipped()
    }
}

// MARK: - Row Sections
private extension HomeView {
    var firstSection : some View {
        HStack {
            dailyStepCountView
            streakView
        }
    }
    
    var secondSection : some View {
        monthlyStepsView
    }
}

// MARK: - Daily Steps
private extension HomeView {
    @ViewBuilder var dailyStepCountView : some View {
        DailyStepCountView(steps: viewModel.dailySteps,
                           stepGoal: viewModel.dailyStepGoal,
                           isLoading: viewModel.dailyStepsAreLoading) {
            self.presentDailyStepGoalSheet = true
        }
    }
}

// MARK: - Monthly Steps
private extension HomeView {
    @ViewBuilder var monthlyStepsView : some View {
        CardView(title: "monthly_steps_title", height: 275) {
            if viewModel.monthlyStepsAreLoading {
                LoadingView()
            } else {
                MonthlyStepsView(monthlySteps: viewModel.monthlySteps,
                                 stepGoal: viewModel.dailyStepGoal)
            }
        }
    }
}

// MARK: - Streak View
private extension HomeView {
    var streakView : some View {
        StreakView(streak: $viewModel.streak)
    }
}

#Preview {
    HomeView()
}
