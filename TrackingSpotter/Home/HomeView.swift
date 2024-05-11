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
                    dailyStepsView
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

// MARK: - Card View
private extension HomeView {
    func cardView(_ contentIsAvailable : Bool, _ view : some View) -> some View {
        VStack {
            if !contentIsAvailable {
                CustomContentUnavailableView()
            } else {
                view
            }
        }
        .frame(height: 200)
        .withCardModifier()
    }
}

// MARK: - Steps View
private extension HomeView {
    var stepCountView : some View {
        cardView(viewModel.healthKitContentIsAvailable, StepCountView(steps: viewModel.steps,
                                                                      stepGoal: viewModel.stepGoal,
                                                                      isLoading: viewModel.stepsIsLoading))
        .onTapGesture {
            self.presentSheet = true
        }
    }
}

// MARK: - Daily Steps View
private extension HomeView {
    var dailyStepsView : some View {
        cardView(viewModel.healthKitContentIsAvailable, DailyStepsView(dailySteps: viewModel.dailySteps,
                                                                       stepGoal: viewModel.stepGoal,
                                                                       isLoading: viewModel.dailyStepsIsLoading))
    }
}
