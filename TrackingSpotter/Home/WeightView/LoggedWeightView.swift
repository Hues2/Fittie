import SwiftUI

struct LoggedWeightView : View {
    let loggedWeight : Weight
    
    var body: some View {
        VStack(spacing: 12) {
            Text("logged_weight_view_title")
                .font(.title)
            
            HStack(spacing: 12) {
                Text("\(loggedWeight.kg.toTwoDecimalPlacesString())")
                Text("log_weight_kg_label")
            }
            .font(.system(size: Constants.bigTextSize))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
        }
    }
}
