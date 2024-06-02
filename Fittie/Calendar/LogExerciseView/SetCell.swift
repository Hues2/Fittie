import SwiftUI

struct SetCell: View {
    let index : Int
    let kg : Double
    let reps : Int
    
    var body: some View {
        HStack {
            Text("Set \(index)")
                .font(.title3)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("\(kg.toTwoDecimalPlacesString())")
                Text("\(reps)")
            }
            .font(.title3)
        }
        .padding()
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    SetCell(index: 1, kg: 22.5, reps: 10)
}
