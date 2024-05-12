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
            viewModel.getTodaysSteps()
            viewModel.getPast7DaysSteps()
        }
        .sheet(isPresented: $presentSheet, content: {
            UpdateStepTargetView(stepGoal: $viewModel.stepGoal)
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
            VStack(alignment: .leading, spacing: 0) {
                stepsSection
                    .padding(.top)
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
        .clipped()
    }
}

// MARK: - Steps Section
private extension HomeView {
    var stepsSection : some View {
        VStack(alignment: .leading, spacing: 8) {
            stepsTitle
            HStack {
                stepCountView
                dailyStepsView
            }
        }
    }
    
    var stepsTitle : some View {
        Text("steps_title")
            .font(.title2)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder var stepCountView : some View {
        if viewModel.stepsIsLoading {
            loadingView
                .frame(height: 200)
                .withCardModifier()
        } else {
            StepCountView(steps: viewModel.steps,
                          stepGoal: viewModel.stepGoal,
                          isLoading: viewModel.stepsIsLoading)
            .frame(height: 200)
            .withCardModifier()
            .onTapGesture {
                self.presentSheet = true
            }
            .overlay(alignment: .topTrailing) {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(Color.lightGray)
                    .padding(4)
            }
        }
    }
    
    @ViewBuilder var dailyStepsView : some View {
        VStack {
            if viewModel.dailyStepsIsLoading {
                loadingView
            } else {
                DailyStepsView(dailySteps: viewModel.dailySteps,
                               stepGoal: viewModel.stepGoal)
            }
        }
        .frame(height: 200)
        .withCardModifier()
    }
}

// MARK: - Loading View
private extension HomeView {
    var loadingView : some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
