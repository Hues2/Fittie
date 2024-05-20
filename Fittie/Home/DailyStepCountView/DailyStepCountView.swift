import SwiftUI

struct DailyStepCountView: View {    
    let steps : Int?
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
            .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

private extension DailyStepCountView {
    var content : some View {
        HStack {
            Text("\(steps ?? 0)")            
        }
        .font(.system(size: Constants.bigTextSize))        
        .fontWeight(.semibold)
        .foregroundStyle(.primary)
        .lineLimit(1)
        .minimumScaleFactor(Constants.minimumScaleFactor)
    }
}

#Preview {
    HStack {
        DailyStepCountView(steps: 10000,
                           isLoading: false)
        Spacer()
            .frame(width: 175)
    }
}
