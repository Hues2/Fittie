import SwiftUI

struct SetWeightGoalView: View {
    @Binding var weightGoal : Double?
    @State private var weightIsValid : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            OnboardingTitleAndSubtitle(title: "onboarding_set_weight_goal_title",
                                       subtitle: "onboarding_set_weight_goal_subtitle")
            WeightInput(value: $weightGoal,
                        weightIsValid: $weightIsValid,
                        formatStyle: .number,
                        promptText: "80.4")
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }
}

#Preview {
    SetWeightGoalView(weightGoal: .constant(80.5))
}
