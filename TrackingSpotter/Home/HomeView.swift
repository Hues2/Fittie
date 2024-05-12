import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var presentSheet: Bool = false
    @State private var detentHeight: CGFloat = 0
    
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
        .sheet(isPresented: $presentSheet, content: {
            UpdateStepTargetView(stepGoal: $viewModel.dailyStepGoal)
                .presentationCornerRadius(Constants.sheetCornerRadius)
                .readHeight()
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    if let height {
                        self.detentHeight = height
                    }
                }
                .presentationDetents([.height(self.detentHeight)])
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
    
    func sectionTitle(_ title : LocalizedStringKey) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.thin)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var loadingView : some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        self.presentSheet = true
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
            StreakView(streak: 5)
        }
    }
}

#Preview {
    HomeView()
}
