import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused : Bool
    @StateObject private var viewModel = OnboardingViewModel()
    
    @State private var onBoardingPage : OnboardingPage = .setStepGoal
    @State private var onBoardingPageId : Int?
    
    @Binding var hasSeenOnboarding : Bool
    
    var body: some View {
        VStack {
            pageControlView
                .padding(.horizontal, 24)
                .padding(.top, 20)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    setStepGoalView
                    
                    setWeightGoalView
                    
                    activityPermissionsView
                    
                    allSetView
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $onBoardingPageId)
            .contentMargins(.zero)
            .scrollDisabled(true)
            
            nextPageButton
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
                .padding(20)
        }
    }
}

// MARK: Pages
private extension OnboardingView {
    var setStepGoalView : some View {
        SetStepGoalView(stepGoal: $viewModel.stepGoal)
            .id(OnboardingPage.setStepGoal.id)
            .containerRelativeFrame(.horizontal)
    }
    
    var setWeightGoalView : some View {
        SetWeightGoalView(isFocused: $isFocused, weightGoal: $viewModel.weightGoal)
            .id(OnboardingPage.setWeightGoal.id)
            .containerRelativeFrame(.horizontal)
    }
    
    var activityPermissionsView : some View {
        ActivityPermissionsView()
            .id(OnboardingPage.getHealthKitPermission.id)
            .containerRelativeFrame(.horizontal)
    }
    
    var allSetView : some View {
        AllSetView()
            .id(OnboardingPage.allSet.id)
            .containerRelativeFrame(.horizontal)
    }
}

// MARK: Page Indicator
private extension OnboardingView {
    @ViewBuilder var pageControlView : some View {
        if onBoardingPage != .allSet {
            pageControlCircleView
        }
    }
    
    var pageControlCircleView : some View {
        HStack(spacing: 16) {
            ForEach(OnboardingPage.allCases.indices, id:\.self) { index in
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(onBoardingPage.rawValue >= index ? Color.accentColor : Color.secondary)
                    .frame(height: 2)
                    .frame(maxWidth: onBoardingPage.rawValue >= index ? .infinity : 24)
            }
        }
    }
}

// MARK: Back Button
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
}

// MARK: Next Page Button
private extension OnboardingView {
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
                self.onBoardingPage = nextPage
                self.onBoardingPageId = nextPage.id
            }
        }
    }
    
    private func previousPage() {
        self.isFocused = false
        if let previousPage = OnboardingPage(rawValue: onBoardingPage.rawValue - 1) {
            withAnimation {
                self.onBoardingPage = previousPage
                self.onBoardingPageId = previousPage.id
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
