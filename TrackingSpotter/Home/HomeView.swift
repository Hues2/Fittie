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
        }
        .sheet(isPresented: $presentDailyStepGoalSheet, content: {
            UpdateStepTargetView(stepGoal: $viewModel.dailyStepGoal)
                .withCustomSheetHeight()
        })
        .sheet(isPresented: $viewModel.presentStreakPrompt, content: {
            StreakPromptView { userHasWorkedOut in
                viewModel.updateStreak(userHasWorkedOut)
            }
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
    
    func cardView(_ title : LocalizedStringKey, _ height : CGFloat, @ViewBuilder cardContent : @escaping () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle(title)
            cardContent()
        }
        .frame(height: height)
        .withCardModifier()
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
        cardView("daily_steps_title", Constants.cardHeight) {
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
        .overlay(alignment: .topTrailing) {
            if !viewModel.dailyStepsAreLoading {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(Color.lightGray)
                    .padding(6)
            }
        }
    }
}

// MARK: - Monthly Steps
private extension HomeView {
    @ViewBuilder var monthlyStepsView : some View {
        cardView("monthly_steps_title", 275) {
            if viewModel.monthlyStepsAreLoading {
                loadingView
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
        cardView("streak_title", Constants.cardHeight) {
            StreakView(streak: viewModel.streak)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.dailyStepsAreLoading {
                Image(systemName: "flame")
                    .padding(6)
                    .foregroundStyle(Color.orange)                    
            }
        }
    }
}

#Preview {
    HomeView()
}
