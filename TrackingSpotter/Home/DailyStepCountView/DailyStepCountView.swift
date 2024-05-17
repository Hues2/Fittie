import SwiftUI

struct DailyStepCountView: View {    
    let steps : Int?
    let stepGoal : Int
    let isLoading : Bool
    
    var body: some View {
        CardView(title: "daily_steps_title", height: Constants.cardHeight) {
            VStack {
                if isLoading {
                    LoadingView()
                } else {
                    content
                }
            }
            .foregroundStyle(Color.customText)
            .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
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
        VStack(spacing: 0) {
            valueView("current_steps_title", steps, "shoeprints.fill")
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
