import SwiftUI

struct HomeCardGroupBoxStyle : GroupBoxStyle {
    let height : CGFloat
    let icon : String?
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                }
                configuration.label
            }
            .foregroundStyle(Color.secondaryAccent)
            
            configuration.content
                .frame(height: height)
        }
        .padding()
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    BasicInfoCardView(value: "1098", title: "Title", unit: "Steps", icon: "shoeprints.fill", isLoading: false)
}
