import SwiftUI
import Charts

struct DailyStepsView: View {
    let dailySteps : [DailyStep]
    let stepGoal : Int
    let isLoading : Bool
    
    var body: some View {
        VStack {
            if isLoading {
                loadingView
            } else {
                chart
            }
        }
    }
}

private extension DailyStepsView {
    var loadingView : some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var chart : some View {
        Chart {
            ForEach(dailySteps) { dailyStep in
                BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day),
                        y: .value("Steps", dailyStep.steps))
                .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent : Color.red)
            }
        }
    }
}

#Preview {
    DailyStepsView(dailySteps: [DailyStep(date: Date(), steps: 11632),
                                          DailyStep(date: Date(), steps: 1789),
                                          DailyStep(date: Date(), steps: 1686),
                                          DailyStep(date: Date(), steps: 1478),
                                          DailyStep(date: Date(), steps: 1397),
                                          DailyStep(date: Date(), steps: 922),
                                          DailyStep(date: Date(), steps: 2408)],
                   stepGoal: 1400,
                   isLoading: false)
    .frame(width: 300)
}
