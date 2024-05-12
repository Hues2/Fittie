import SwiftUI
import Charts

struct WeeklyStepsView: View {
    @State var weeklySteps : [DailyStep]
    let stepGoal : Int
    
    var body: some View {
        chart()
            .padding(.top, 4)
    }
}

private extension WeeklyStepsView {    
    @ViewBuilder func chart() -> some View {
        Chart {
            ForEach(weeklySteps) { dailyStep in
                BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day),
                        y: .value("Steps", dailyStep.animate ? dailyStep.steps : 0))
                .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent : Color.red)
            }
        }
        .chartYScale(domain: 0...(stepGoal + 1000))
        .onAppear {
            for (index, _) in weeklySteps.enumerated() {
                withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1)) {
                    weeklySteps[index].animate = true
                }
            }
        }
        .clipped()
    }
}

#Preview {
    WeeklyStepsView(weeklySteps: [DailyStep(date: Date(), steps: 11632),
                                          DailyStep(date: Date(), steps: 1789),
                                          DailyStep(date: Date(), steps: 1686),
                                          DailyStep(date: Date(), steps: 1478),
                                          DailyStep(date: Date(), steps: 1397),
                                          DailyStep(date: Date(), steps: 922),
                                          DailyStep(date: Date(), steps: 2408)],
                   stepGoal: 1400)
    .frame(width: 300)
}
