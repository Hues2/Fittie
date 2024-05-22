import SwiftUI
import Charts

struct WeightChartView: View {
    let loggedWeights : [Weight]
    @Binding var weightGoal : Double?
    private let gradient = LinearGradient(
        gradient: Gradient (
            colors: [
                Color.accentColor.opacity(0.4),
                Color.accentColor.opacity(0.0),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        lineChart
            .clipped()
            .frame(maxHeight: .infinity)
            .padding(.top, 8)
    }
}

private extension WeightChartView {
    var lineChart : some View {
        Chart {
            if let weightGoal {
                RuleMark(y: .value("Weight Goal", weightGoal))
                    .foregroundStyle(Color.pink.gradient)
            }
            
            ForEach(loggedWeights) { loggedWeight in
                LineMark(
                    x: .value("Date", loggedWeight.date),
                    y: .value("Weight", loggedWeight.kg)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.accentColor.gradient)
                .symbol {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 10, height: 10)
                        .overlay {
                            Circle()
                                .fill(Material.thick)
                                .frame(width: 8, height: 8)
                        }
                }
                
                AreaMark(
                    x: .value("Date", loggedWeight.date),
                    y: .value("Weight", loggedWeight.kg)
                )
                .alignsMarkStylesWithPlotArea()
                .interpolationMethod(.catmullRom)
                .foregroundStyle(gradient)
            }
        }
        .chartXAxis {
            AxisMarks { mark in
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks { mark in
                AxisValueLabel()
                AxisGridLine(centered: false, stroke: .init(lineWidth: 1, dash: [5]))
                    .foregroundStyle(Color.lightGray)
                
            }
        }
        .chartYScale(domain: getMinYValue()...getMaxYValue())
    }
    
    func getMinYValue() -> Double {
        var minValue = loggedWeights.map({ $0.kg }).min() ?? .zero
        if let weightGoal {
            minValue = min(minValue, weightGoal)
        }
        return minValue - 2
    }
    
    func getMaxYValue() -> Double {
        var maxValue = loggedWeights.map({ $0.kg }).max() ?? .zero
        if let weightGoal {
            maxValue = max(maxValue, weightGoal)
        }
        return maxValue + 2
    }
}
