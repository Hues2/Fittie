import SwiftUI

struct SetCell: View {
    let index : Int
    let kg : Double
    let reps : Int
    
    var body: some View {
        HStack {
            Text("Set \(index)")
                .fontWeight(.semibold)
                .padding()
                .background(.accent.opacity(0.8))
            
            Text("\(kg.toTwoDecimalPlacesString()) " + NSLocalizedString("kg_unit", comment: "Kg"))
                .foregroundStyle(.secondary)
                .fontWeight(.light)
                .frame(maxWidth: .infinity)
            
            Text("\(reps) " + NSLocalizedString("reps_unit", comment: "Reps"))
                .foregroundStyle(.secondary)
                .fontWeight(.light)
                .padding(.trailing)
        }
        .font(.title3)
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    SetCell(index: 1, kg: 22.5, reps: 10)
}
