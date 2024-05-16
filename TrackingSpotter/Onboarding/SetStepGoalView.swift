import SwiftUI

struct SetStepGoalView: View {
    @Binding var stepGoal : Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            title
            subtitle
            StepperView(stepGoal: $stepGoal)
                .frame(maxHeight: .infinity)    
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)        
        .padding(.vertical, 32)     
        .padding(.horizontal, 24)
    }
}

private extension SetStepGoalView {
    var title : some View {
        Text("onboarding_set_step_goal_title")
            .foregroundStyle(Color.customText)
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    var subtitle : some View {
        Text("onboarding_set_step_goal_subtitle")
            .foregroundStyle(Color.customText)
            .font(.headline)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)            
    }
}

#Preview {
    SetStepGoalView(stepGoal: .constant(10000))
}
