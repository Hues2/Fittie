import SwiftUI

struct BasicInfoCardView: View {
    let value : String
    let title : LocalizedStringKey
    let unit : LocalizedStringKey
    let icon : String
    let isLoading : Bool
    
    var body: some View {
        CardView(icon: icon, title: title, height: Constants.cardHeight) {
            VStack {
                if isLoading {
                    LoadingView()
                } else {
                    content
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

private extension BasicInfoCardView {
    var content : some View {
        VStack {
            Text("\(value)")
                .font(.system(size: Constants.bigCardTextSize))
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(Constants.minimumScaleFactor)
            
            Text(unit)
                .font(.body)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(Constants.minimumScaleFactor)
        }
    }
}


#Preview {
    BasicInfoCardView(value: "1098", title: "Title", unit: "Steps", icon: "shoeprints.fill", isLoading: false)
}
