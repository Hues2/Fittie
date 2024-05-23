import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Namespace private var namespace
    
    var body: some View {
        content
            .onAppear {
                viewModel.getDailySteps()
                viewModel.getActiveBurnedEnergy()
            }
            .navigationTitle("home_nav_title")
    }
}

// MARK: - View Content
private extension HomeView {
    var content : some View {
        ScrollView {
            VStack {
                firstSection
                secondSection
                thirdSection
            }
            .padding(.horizontal, Constants.horizontalScrollviewPadding)
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Row Sections
private extension HomeView {
    var firstSection : some View {
        HStack(spacing: 12) {
            dailyStepCountView
            activeBurnedEnergy
        }
    }
    
    var secondSection : some View {
        averageStepsView
    }
    
    var thirdSection : some View {
        weightView
            .matchedGeometryEffect(id: "weight_view", in: namespace)
    }
}

// MARK: - Daily Steps
private extension HomeView {
    @ViewBuilder var dailyStepCountView : some View {
        BasicInfoCardView(value: "\(viewModel.todaysSteps)",
                          title: "daily_steps_title",
                          unit: "daily_steps_unit",
                          icon: "shoeprints.fill",
                          isLoading: viewModel.dailyStepsAreLoading)
    }
}

// MARK: - Burned Active Energy
private extension HomeView {
    var activeBurnedEnergy : some View {
        BasicInfoCardView(value: "\(Int(viewModel.activeBurnedEnergy))",
                          title: "active_burned_energy_title",
                          unit: "active_burned_energy_kilocalorie_unit",
                          icon: "flame.fill",
                          isLoading: viewModel.burnedEnergyIsLoading)
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
        WeightView(weightGoal: $viewModel.weightGoal)
            .padding(.bottom, 12)            
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
