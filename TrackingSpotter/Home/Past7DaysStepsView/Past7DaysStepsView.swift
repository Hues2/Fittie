import SwiftUI
import Charts

struct Past7DaysStepsView: View {
    let dailySteps : [DailyStep]
    
    var body: some View {
        VStack {             
            Chart {
                ForEach(dailySteps) { dailyStep in
                    BarMark(x: .value(dailyStep.date.formatted(), dailyStep.date), y: .value("Steps", dailyStep.steps))
                }
            }
        }
    }
}

//#Preview {
//    Past7DaysStepsView()
//}
