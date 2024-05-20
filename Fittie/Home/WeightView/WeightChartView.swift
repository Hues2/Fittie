import SwiftUI
import Charts

struct WeightChartView: View {
    let loggedWeights : [Weight]
    
    var body: some View {
        lineChart
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
                
                PointMark(
                    x: .value("Date", loggedWeight.date),
                    y: .value("Weight", loggedWeight.kg)
                )
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
