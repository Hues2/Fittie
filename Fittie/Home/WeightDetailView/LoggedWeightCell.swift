import SwiftUI

struct LoggedWeightCell: View {
    let date : Date
    let kg : Double
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "scalemass")
                    .foregroundStyle(.pink)
                Text(kg.toTwoDecimalPlacesString() + NSLocalizedString("log_weight_kg_label", comment: "Kg unit"))
            }
            .font(.title3)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(date.formattedWithOrdinalSuffix())
                .font(.headline)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
        .background(Material.thick)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    VStack {
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
    }
}
