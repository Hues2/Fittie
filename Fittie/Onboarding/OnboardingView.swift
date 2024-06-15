import SwiftUI

enum OnboardingPage : Int, CaseIterable {
    case setStepGoal = 0
    case setWeightGoal = 1
    case getHealthKitPermission = 2
    case allSet = 3
    
    var buttonTitle : LocalizedStringKey {
        switch self {
        case .setStepGoal:
            return "onboarding_next_button_title"
        case .setWeightGoal:
            return "onboarding_next_button_title"
        case .getHealthKitPermission:
            return "onboarding_set_permissions_button_title"
        case .allSet:
            return "onboarding_finish_button_title"
        }
    }
}

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused : Bool
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var onBoardingPage : OnboardingPage = .setStepGoal
    @Binding var hasSeenOnboarding : Bool
    
    var body: some View {
        VStack {
            TabView(selection: $onBoardingPage) {
                SetStepGoalView(stepGoal: $viewModel.stepGoal)
                    .tag(OnboardingPage.setStepGoal)
                
                SetWeightGoalView(isFocused: $isFocused, weightGoal: $viewModel.weightGoal)
                    .tag(OnboardingPage.setWeightGoal)
                
                ActivityPermissionsView()
                    .tag(OnboardingPage.getHealthKitPermission)
                
                AllSetView()
                    .tag(OnboardingPage.allSet)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            pageControlView
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 32)
        .padding(.top, 52)
        .contentShape(RoundedRectangle(cornerRadius: Constants.sheetCornerRadius))
        .onTapGesture {
            self.isFocused = false
        }
        .overlay(alignment: .topLeading) {
            backButton
                .padding(16)
        }
        .onAppear {
            // Block the swipe gesture for the tab view
            UIScrollView.appearance().isScrollEnabled = false
        }
    }
}

private extension OnboardingView {
    @ViewBuilder var backButton : some View {
        if onBoardingPage != .setStepGoal && onBoardingPage != .allSet {
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
            if onBoardingPage != .allSet {
                pageControlCircleView
            }
            nextPageButton
        }
    }
    
    var pageControlCircleView : some View {
        HStack(spacing: 16) {
            ForEach(OnboardingPage.allCases.indices, id:\.self) { index in
                Circle()
                    .fill(onBoardingPage.rawValue >= index ? Color.accentColor : Color.secondary)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    var nextPageButton : some View {
        CustomButton(title: self.onBoardingPage.buttonTitle) {
            buttonAction()
        }
        .padding(.bottom, 4)
        .animation(.none, value: onBoardingPage)
    }
}

// MARK: Button functionality
private extension OnboardingView {
    private func buttonAction() {
        switch onBoardingPage {
        case .setStepGoal:
            nextPage()
        case .setWeightGoal:
            nextPage()
        case .getHealthKitPermission:
            viewModel.setPermissions {
                nextPage()
            }
        case .allSet:
            self.isFocused = false
            viewModel.finishOnboarding()
            dismiss()
            self.hasSeenOnboarding = true
        }
    }
    
    private func nextPage() {
        self.isFocused = false
        if let nextPage = OnboardingPage(rawValue: onBoardingPage.rawValue + 1) {
            withAnimation {
                onBoardingPage = nextPage
            }
        }
    }
    
    private func previousPage() {
        self.isFocused = false
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
            .presentationCornerRadius(Constants.sheetCornerRadius)
    })
}
