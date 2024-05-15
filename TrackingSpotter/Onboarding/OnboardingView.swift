import SwiftUI

enum OnboardingPage : Int, CaseIterable {
    case setStepGoal = 0
    case getHealthKitPermission = 1
}

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var onBoardingPage : OnboardingPage = .setStepGoal
    
    var body: some View {
        VStack {
            VStack {
                switch onBoardingPage {
                case .setStepGoal:
                    SetStepGoalView(stepGoal: $viewModel.stepGoal) {
                        viewModel.setStepGoal()
                    }
                    .transition(.move(edge: .leading))
                case .getHealthKitPermission:
                    Text("REQUEST HEALTH KIT AUTH")
                        .transition(.move(edge: .trailing))
                }
            }
            .frame(maxHeight: .infinity)
            
            pageControlView
        }
    }
}

private extension OnboardingView {
    var pageControlView : some View {
        VStack(spacing: 16) {
            pageControlCircleView
            nextPageButton
        }
        .padding()
    }
    
    var pageControlCircleView : some View {
        HStack(spacing: 16) {
            ForEach(OnboardingPage.allCases.indices, id:\.self) { index in
                Circle()
                    .fill(onBoardingPage.rawValue >= index ? Color.accentColor : Color.lightGray)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    var nextPageButton : some View {
        CustomButton(title: onBoardingPage == OnboardingPage.allCases.last ?
                     "onboarding_finish_button_title" : "onboarding_next_button_title") {
            nextpage()
        }
    }
    
    private func nextpage() {
        if let nextPage = OnboardingPage(rawValue: onBoardingPage.rawValue + 1) {
            withAnimation {
                onBoardingPage = nextPage
            }
        } else {
            viewModel.finishOnboarding()
        }
    }
}

#Preview {
    OnboardingView()
}
