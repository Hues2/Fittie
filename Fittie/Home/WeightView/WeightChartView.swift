import SwiftUI
import Charts

struct WeightChartView: View {
    let loggedWeights : [Weight]
    @Binding var weightGoal : Double?
    var showXAxis : Bool = true
    let logFirstEntryAction : (() -> Void)
    
    var body: some View {
        if !loggedWeights.isEmpty {
            VStack(spacing: 12) {
                averageWeightView
                lineChart
                chartLegend
            }
        } else {
            CustomContentUnavailableView(title: "not_available_title",
                                         description: "weight_content_unavailable_description",
                                         buttonTitle: "weight_content_unavailable_button_title") {
                logFirstEntryAction()
            }
        }
    }
}

// MARK: Average weight
private extension WeightChartView {
    var averageWeightView : some View {
        HStack(spacing: 2) {
            Text(String(format: NSLocalizedString("average_steps_average_steps", comment: "Avg:"), averageWeight()))
                .font(.footnote)            
                .foregroundStyle(.secondary)
            
            Text("log_weight_kg_label")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func averageWeight() -> String {
        guard loggedWeights.count > 0 else { return "-" }
        let average : Double = loggedWeights.reduce(0, { $0 + $1.kg }) / Double(loggedWeights.count)
        return average.toTwoDecimalPlacesString()
    }
}

// MARK: Chart
private extension WeightChartView {
    var lineChart : some View {
        Chart {
            if let weightGoal {
                RuleMark(y: .value("Weight Goal", weightGoal))
                    .foregroundStyle(Color.pink.gradient)
            }
            
            ForEach(loggedWeights.suffix(Constants.numberOfLoggedWeights)) { loggedWeight in
                LineMark(
                    x: .value("Date", loggedWeight.date),
                    y: .value("Weight", loggedWeight.kg)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.accentColor.gradient)
                .symbol {
                    Circle()
                        .fill(Color.accentColor.gradient)
                        .frame(width: 10, height: 10)
                        .overlay {
                            Circle()
                                .fill(Constants.backgroundMaterial)
                                .frame(width: 8, height: 8)
                        }
                }
            }
        }
        .chartXAxis(showXAxis ? .visible : .hidden)
        .chartXAxis {
            AxisMarks { mark in
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 2)) { value in
                AxisValueLabel()
                AxisGridLine(centered: false, stroke: .init(lineWidth: 1, dash: [8]))
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
        return max((minValue - 2), 0)
    }
    
    func getMaxYValue() -> Double {
        var maxValue = loggedWeights.map({ $0.kg }).max() ?? .zero
        if let weightGoal {
            maxValue = max(maxValue, weightGoal)
        }
        return maxValue + 2
    }
}

// MARK: Chart legend
private extension WeightChartView {
    var chartLegend : some View {
        HomeViewChartLegend(title: "weight_chart_legend_weight_goal")
    }
}

#Preview {
    WeightDetailView()
}
