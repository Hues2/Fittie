import SwiftUI

struct StepGoalView: View {
    let stepGoal : Int
    let achievedStepGoals : Int
    let isLoading : Bool
    
    var body: some View {
        CardView(title: "step_goal_title", height: Constants.cardHeight) {
            VStack {
                if isLoading {
                    LoadingView()
                } else {
                    content
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

private extension StepGoalView {
    var content : some View {
        VStack(spacing: 0) {
            valueView("step_goal_goal_title", stepGoal, "target")
            valueView("step_goal_achieved", achievedStepGoals, "trophy.fill")
        }
    }
    
    @ViewBuilder func valueView(_ title : LocalizedStringKey,
                                _ value : Int?,
                                _ icon : String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                Image(systemName: icon)
                    .foregroundStyle(.accent)
                    .font(.title2)
            }
            
            Group {
                if let value {
                    Text("\(value)")
                } else {
                    Text("-")
                }
            }
            .font(.title)
            .fontWeight(.light)
            .foregroundStyle(.secondary)
        }
        .lineLimit(1)
        .minimumScaleFactor(Constants.minimumScaleFactor)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    HStack {
        StepGoalView(stepGoal: 1500, achievedStepGoals: 5, isLoading: false)
            .frame(height: 200)
            .padding()
        
        Spacer()
            .frame(width: 175)
    }
}
