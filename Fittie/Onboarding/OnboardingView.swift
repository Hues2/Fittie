import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused : Bool
    @StateObject private var viewModel = OnboardingViewModel()
    
    @State private var onBoardingPage : OnboardingPage = .setStepGoal
    @State private var onBoardingPageId : Int?
    
    @Binding var hasSeenOnboarding : Bool
    
    // UI Values
    private let animation : Animation = .smooth(duration: 0.4)
    
    var body: some View {
        VStack {
            pageControlView
                .padding(.horizontal, 32)
                .padding(.top, 32)
            
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
        .padding(.bottom, 0)
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
    var pageControlView : some View {
        pageControlCircleView
            .opacity(onBoardingPage != .allSet ? 1 : 0)
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
    var backButton : some View {
        Button {
            previousPage()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accentColor)
                .padding(12)
                .background(.card)
                .clipShape(Circle())
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .scaleEffect(onBoardingPage != .setStepGoal && onBoardingPage != .allSet ? 1 : 0)
        .offset(y: onBoardingPage != .setStepGoal && onBoardingPage != .allSet ? 0 : -24)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            withAnimation(animation) {
                self.onBoardingPage = nextPage
                self.onBoardingPageId = nextPage.id
            }
        }
    }
    
    private func previousPage() {
        self.isFocused = false
        if let previousPage = OnboardingPage(rawValue: onBoardingPage.rawValue - 1) {
            withAnimation(animation) {
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
