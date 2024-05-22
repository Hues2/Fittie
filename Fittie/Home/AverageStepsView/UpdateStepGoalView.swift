import SwiftUI

struct UpdateStepGoalView: View {
    @Binding var stepGoal : Int
    
    var body: some View {
        VStack(spacing: 40) {
            title
            StepGoalStepperView(stepGoal: $stepGoal)
                .padding(.horizontal, 24)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 48)        
    }
}

private extension UpdateStepGoalView {
    var title : some View {
        HStack {
            Image(systemName: "target")
            Text("step_goal_update_title")
        }
        .foregroundStyle(Color.pink)
        .font(.title)
        .frame(maxWidth: .infinity, alignment: .leading)
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
