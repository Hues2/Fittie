import SwiftUI

struct DailyStepCountView: View {    
    let steps : Int?
    let stepGoal : Int
    let isLoading : Bool
    
    var body: some View {
        VStack {
            if isLoading {
                loadingView
            } else {
                stepsContent
            }
        }
        .foregroundStyle(Color.customText)        
    }
}

private extension DailyStepCountView {
    var loadingView : some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var stepsContent : some View {
        VStack(spacing: 12) {
            valueView("current_steps_title", steps, "figure.walk")
            valueView("target_steps_title", stepGoal, "target")
        }
    }
    
    @ViewBuilder func valueView(_ title : LocalizedStringKey,
                                _ value : Int?,
                                _ icon : String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.medium)
                Image(systemName: icon)
                    .foregroundStyle(.accent)
                    .font(.title)
            }
            
            Group {
                if let value {
                    Text("\(value)")
                } else {
                    Text("-")
                }
            }
            .font(.title)
            .fontWeight(.ultraLight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    HStack {
        DailyStepCountView(steps: 337,
                      stepGoal: 10000,
                      isLoading: false)
        Spacer()
            .frame(width: 175)
    }
}
