import SwiftUI
import Charts

struct AverageStepsView: View {
    @Binding var steps : [DailyStep]
    @Binding var stepGoal : Int
    let isLoading : Bool
    @Binding var selectedPeriod : TimePeriod
    @State private var displayedSteps : [DailyStep] = []
    @State private var isUpdatingStepGoal : Bool = false
    
    var body: some View {
        CardView(icon: "figure.walk", title: "average_steps_title", height: Constants.graphCardHeight) {
            if isLoading {
                LoadingView()
            } else {
                content
            }
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "hand.tap")
                .padding()
                .foregroundStyle(.secondary)
        }
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .onTapGesture {
            self.isUpdatingStepGoal = true
        }
        .sheet(isPresented: $isUpdatingStepGoal) {
            UpdateStepGoalView(stepGoal: $stepGoal)
                .withCustomSheetHeight()
        }
    }
}

// MARK: Content
private extension AverageStepsView {
    var content : some View {
        VStack(spacing: 12) {
            averageStepsView
            chart()
            chartLegend
        }
    }
}

// MARK: Picker
private extension AverageStepsView {
    var picker : some View {
        Picker("", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases) { period in
                Text(period.title).tag(period)
            }
        }
        .pickerStyle(.menu)
        .simultaneousGesture(
            TapGesture().onEnded { }
        )
    }
}

// MARK: Average Steps
private extension AverageStepsView {
    var averageStepsView : some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                Text(String(format: NSLocalizedString("average_steps_average_steps", comment: "Avg:"), averageSteps()))
                    .font(.footnote)                    
                    .foregroundStyle(.secondary)
                
                Image(systemName: "shoeprints.fill")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            picker
        }
    }
    
    func averageSteps() -> String {
        guard displayedSteps.count > 0 else { return "0" }
        return (displayedSteps.reduce(0, { $0 + $1.steps }) / displayedSteps.count).toString
    }
}

// MARK: Chart
private extension AverageStepsView {
    @ViewBuilder func chart() -> some View {
        Chart {
            RuleMark(y: .value("Step Goal", stepGoal))
                .foregroundStyle(Color.pink.gradient)
            
            ForEach(displayedSteps) { dailyStep in
                BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date, unit: .day),
                        y: .value("Steps", dailyStep.animate ? dailyStep.steps : 0))
                .foregroundStyle((dailyStep.steps >= stepGoal) ? Color.accent.gradient : Color.pink.gradient)
                .cornerRadius(2)
            }
        }
        .chartYScale(domain: 0...getMax())
        .chartYAxis {
            AxisMarks { mark in
                AxisValueLabel()
                AxisGridLine(centered: false, stroke: .init(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.lightGray)
                    
            }
        }
        .chartXAxis {
            switch selectedPeriod {
            case .month:
                AxisMarks { mark in
                    AxisTick()
                    AxisValueLabel()
                }
            case .week:
                AxisMarks(values: .stride(by: .day)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(centered: true) {
                            Text(DateFormatter.dayOfWeek.string(from: date))
                        }
                    }
                }
            }
        }
        .onAppear {
            animateGraph()
        }
        .onChange(of: selectedPeriod) {
            animateGraph()
        }        
    }
    
    var chartLegend : some View {
        HomeViewChartLegend(title: "average_steps_chart_legend_step_goal")
    }
    
    func getMax() -> Int {
        let max = displayedSteps.map({ $0.steps }).max()
        return (max ?? .zero) + 500
    }
    
    func animateGraph() {
        // This stops the graph from animating when switching tabs
        guard displayedSteps.count != steps.count else { return }

        self.displayedSteps = steps
        
        for (index, _) in displayedSteps.enumerated() {
            withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.03)) {
                displayedSteps[index].animate = true
            }
        }
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
    return AverageStepsView(steps: .constant(generateMockData()),
                            stepGoal: .constant(Int.random(in: 500...10_000)),
                            isLoading: false,
                            selectedPeriod: .constant(.month))
    .frame(height: 275)
}
