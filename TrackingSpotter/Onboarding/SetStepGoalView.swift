import SwiftUI

struct SetStepGoalView: View {
    @Binding var stepGoal : Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            OnboardingTitleAndSubtitle(title: "onboarding_set_step_goal_title",
                                       subtitle: "onboarding_set_step_goal_subtitle")
            StepperView(stepGoal: $stepGoal)
                .frame(maxHeight: .infinity)    
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        
        .padding(.vertical, 32)     
        .padding(.horizontal, 24)
    }
}

#Preview {
    SetStepGoalView(stepGoal: .constant(10000))
}
