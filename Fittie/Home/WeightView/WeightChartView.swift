import SwiftUI
import Charts

struct WeightChartView: View {
    let loggedWeights : [Weight]
    let gradient = LinearGradient(
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
        let min = loggedWeights.map({ $0.kg }).min()
        return (min ?? .zero) - 2
    }
    
    func getMaxYValue() -> Double {
        let max = loggedWeights.map({ $0.kg }).max()
        return (max ?? .zero) + 2
    }
}
