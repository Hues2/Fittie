import SwiftUI
import Charts

struct DailyStepsView: View {
    @State var dailySteps : [DailyStep]
    let stepGoal : Int
    
    var body: some View {
        chart()
    }
}

private extension DailyStepsView {    
    @ViewBuilder func chart() -> some View {
        let max = dailySteps.max { item1, item2 in
            return item2.steps > item1.steps
        }?.steps ?? 0
        
        Chart {
            ForEach(dailySteps) { dailyStep in
                BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day),
                        y: .value("Steps", dailyStep.animate ? dailyStep.steps : 0))
                .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent : Color.red)
            }
        }
        .chartYScale(domain: 0...(max + 5000))
        .onAppear {
            for (index, _) in dailySteps.enumerated() {
                withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1)) {
                    dailySteps[index].animate = true
                }
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
                   stepGoal: 1400)
    .frame(width: 300)
}
