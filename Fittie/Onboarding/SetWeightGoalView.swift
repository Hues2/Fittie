import SwiftUI

struct SetWeightGoalView: View {
    @FocusState.Binding var isFocused : Bool
    @Binding var weightGoal : Double?
    @State private var weightIsValid : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            OnboardingTitleAndSubtitle(title: "onboarding_set_weight_goal_title",
                                       subtitle: "onboarding_set_weight_goal_subtitle")
            VStack {
                WeightInput(value: $weightGoal,
                            weightIsValid: $weightIsValid,
                            isFocused: $isFocused,
                            formatStyle: .number,
                            promptText: "80.4")
                Text("log_weight_kg_label")
                    .font(.title2)
                    .foregroundStyle(.secondary)                
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .onAppear {
            // There has to be a delay, as this action cancels the paged tab view animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isFocused = true
            }
        }
    }
}
