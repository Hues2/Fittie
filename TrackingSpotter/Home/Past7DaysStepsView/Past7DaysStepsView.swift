import SwiftUI
import Charts

struct Past7DaysStepsView: View {
    let dailySteps : [DailyStep]
    let stepGoal : Int
    
    var body: some View {
        VStack {
            Chart {
                ForEach(dailySteps) { dailyStep in
                    BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day), y: .value("Steps", dailyStep.steps))
                        .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent : Color.red)
                }
            }
        }
        .padding()
        .background(Color.darkGray)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    Past7DaysStepsView(dailySteps: [DailyStep(date: Date(), steps: 11632),
                                    DailyStep(date: Date(), steps: 1789),
                                    DailyStep(date: Date(), steps: 1686),
                                    DailyStep(date: Date(), steps: 1478),
                                    DailyStep(date: Date(), steps: 1397),
                                    DailyStep(date: Date(), steps: 922),
                                    DailyStep(date: Date(), steps: 2408)],
                       stepGoal: 1400)
    .frame(width: 300)
}
