import SwiftUI

enum OnboardingPage : Int, CaseIterable {
    case setStepGoal = 0
    case getHealthKitPermission = 1
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var onBoardingPage : OnboardingPage = .setStepGoal
    @Binding var hasSeenOnboarding : Bool
    
    var body: some View {
        VStack {
            VStack {
                switch onBoardingPage {
                case .setStepGoal:
                    SetStepGoalView(stepGoal: $viewModel.stepGoal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                case .getHealthKitPermission:
                    Text("REQUEST HEALTH KIT AUTH")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
            }
            .padding(.top, 40)
            
            pageControlView
        }
        .overlay(alignment: .topLeading) {
            backButton
                .padding(16)
        }
    }
}

private extension OnboardingView {
    @ViewBuilder var backButton : some View {
        if onBoardingPage != .setStepGoal {
            Button {
                previousPage()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("onboarding_back_button_title")
                }
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        } else {
            EmptyView()
        }
    }
    
    var pageControlView : some View {
        VStack(spacing: 20) {
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
            nextPage()
        }
    }
}

// MARK: Buttomn functionality
private extension OnboardingView {
    private func nextPage() {
        if let nextPage = OnboardingPage(rawValue: onBoardingPage.rawValue + 1) {
            withAnimation {
                onBoardingPage = nextPage
            }
        } else {
            viewModel.finishOnboarding {
                dismiss()
                self.hasSeenOnboarding = true
            }
        }
    }
    
    private func previousPage() {
        if let previousPage = OnboardingPage(rawValue: onBoardingPage.rawValue - 1) {
            withAnimation {
                onBoardingPage = previousPage
            }
        }
    }
}

#Preview {
    VStack {
        Text("")
    }
    .sheet(isPresented: .constant(true), content: {
        OnboardingView(hasSeenOnboarding: .constant(false))
    })
}
