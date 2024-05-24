import SwiftUI

struct LoggedWeightCell: View {
    let date : Date
    let weight : Double
    var body: some View {
        HStack {
            
        }
    }
}

#Preview {
    LoggedWeightCell(date: .now, weight: 86.8)
        .frame(height: 100)
}
