import SwiftUI
import Charts

struct MonthlyStepsView: View {
    @State var monthlySteps : [DailyStep]
    let stepGoal : Int
    
    var body: some View {
        VStack {
            totalSteps
            chart()
            chartLegend
                .padding(.top, 8)
        }
    }
}

private extension MonthlyStepsView {
    var totalSteps : some View {
        Text(String(format: NSLocalizedString("monthly_steps_average_steps", comment: "Avg:"), averageSteps()))
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func averageSteps() -> String {
        guard monthlySteps.count > 0 else { return "0" }
        return (monthlySteps.reduce(0, { $0 + $1.steps }) / monthlySteps.count).toString
    }
    
    var chartLegend : some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.pink)
                .frame(height: 1)
                .frame(width: 20)
            
            Text("monthly_steps_chart_legend_step_goal")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: Chart
private extension MonthlyStepsView {
    @ViewBuilder func chart() -> some View {
        Chart {
            RuleMark(y: .value("Step Goal", stepGoal))
                .foregroundStyle(Color.pink.gradient)
            
            ForEach(monthlySteps) { dailyStep in
                BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day),
                        y: .value("Steps", dailyStep.animate ? dailyStep.steps : 0))
                .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent.gradient : Color.pink.gradient)
                .cornerRadius(2)
            }
        }
        .chartYScale(domain: 0...(getMax() + 1000))
        .chartYAxis {
            AxisMarks { mark in
                AxisValueLabel()
                AxisGridLine(centered: false, stroke: .init(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.lightGray)
                    
            }
        }
        .chartXAxis(.hidden)
        .onAppear {
            for (index, _) in monthlySteps.enumerated() {
                withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.03)) {
                    monthlySteps[index].animate = true
                }
            }
        }
    }
    
    func getMax() -> Int {
        return monthlySteps.max { item1, item2 in
            return item2.steps > item1.steps
        }?.steps ?? 0
    }
}

#Preview {
    func randomStepCount() -> Int {
        return Int.random(in: 200...10_000)
    }

    // Function to generate an array of DailyStep objects
    func generateMockData() -> [DailyStep] {
        var mockData: [DailyStep] = []
        let currentDate = Date()

        // Generate data for the last 30 days
        for i in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: currentDate)!
            let steps = randomStepCount()
            let dailyStep = DailyStep(date: date, steps: steps)
            mockData.append(dailyStep)
        }

        return mockData.sorted(by: { $0.date < $1.date })
    }
    return MonthlyStepsView(monthlySteps: generateMockData(),
                            stepGoal: Int.random(in: 500...10_000))
    .frame(height: 275)
}
