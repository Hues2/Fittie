import SwiftUI

struct DailyStepCountView: View {    
    let steps : Int?
    let stepGoal : Int
    let isLoading : Bool
    let action : () -> Void
    
    var body: some View {
        CardView(title: "daily_steps_title", height: Constants.cardHeight) {
            content
        }
        .overlay(alignment: .topTrailing) {
            if !isLoading {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(Color.lightGray)
                    .padding(6)
            }
        }
    }
}

private extension DailyStepCountView {
    var content : some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                stepsContent
            }
        }
        .foregroundStyle(Color.customText)
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .onTapGesture {
            action()
        }
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
                           isLoading: false) {
            
        }
        Spacer()
            .frame(width: 175)
    }
}
