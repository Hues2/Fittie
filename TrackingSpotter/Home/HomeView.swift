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
            viewModel.getWeeklySteps()
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
    
    var loadingView : some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func sectionTitle(_ title : LocalizedStringKey) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.thin)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func cardView(_ title : LocalizedStringKey, _ cardContent : @escaping () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle(title)
            cardContent()
        }
        .frame(height: Constants.cardHeight)
        .withCardModifier()
    }
}

// MARK: - Home View Content
private extension HomeView {
    var content : some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 24) {
                firstSection
                    .padding(.top)
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
            weeklyStepsView
        }
    }
    
    var secondSection : some View {
        HStack {
            streakView
            streakView
        }
    }
}

// MARK: - Daily Steps
private extension HomeView {
    @ViewBuilder var dailyStepCountView : some View {
        cardView("daily_steps_title") {
            VStack {
                if viewModel.dailyStepsAreLoading {
                    loadingView
                } else {
                    DailyStepCountView(steps: viewModel.dailySteps,
                                  stepGoal: viewModel.dailyStepGoal,
                                  isLoading: viewModel.dailyStepsAreLoading)
                    .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .onTapGesture {
                        self.presentDailyStepGoalSheet = true
                    }
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.dailyStepsAreLoading {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(Color.lightGray)
                    .padding(4)
            }
        }
    }
}

// MARK: - Weekly Steps
private extension HomeView {
    @ViewBuilder var weeklyStepsView : some View {
        cardView("weekly_steps_title") {
            VStack {
                if viewModel.weeklyStepsAreLoading {
                    loadingView
                } else {
                    WeeklyStepsView(weeklySteps: viewModel.weeklySteps,
                                   stepGoal: viewModel.dailyStepGoal)
                }
            }
        }
    }
}

// MARK: - Streak View
private extension HomeView {
    var streakView : some View {
        cardView("streak_title") {
            StreakView(streak: viewModel.workoutStreak)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.dailyStepsAreLoading {
                Text("🔥")
                    .padding(4)
            }
        }
    }
}

#Preview {
    HomeView()
}
