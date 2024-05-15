import SwiftUI

struct SetStepGoalView: View {
    @Binding var stepGoal : Int
    let action : () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            title
            subtitle
            StepperView(stepGoal: $stepGoal)
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal)
        .padding(.vertical, 32)
        .padding(.top, 32)
    }
}

private extension SetStepGoalView {
    var title : some View {
        Text("onboarding_set_step_goal_title")
            .foregroundStyle(Color.customText)
            .font(.largeTitle)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var subtitle : some View {
        Text("onboarding_set_step_goal_subtitle")
            .foregroundStyle(Color.customText)
            .font(.headline)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    SetStepGoalView(stepGoal: .constant(10000)) {
        
    }
}
