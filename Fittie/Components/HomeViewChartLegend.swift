import SwiftUI

struct HomeViewChartLegend: View {
    let title : LocalizedStringKey
    let color : Color = Constants.Colors.secondaryAccent
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(height: 1)
                .frame(width: 20)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeViewChartLegend(title: "average_steps_chart_legend_step_goal")
}
