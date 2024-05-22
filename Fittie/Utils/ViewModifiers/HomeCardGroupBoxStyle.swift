import SwiftUI

struct HomeCardGroupBoxStyle : GroupBoxStyle {
    let height : CGFloat
    let icon : String
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                configuration.label
            }
            .foregroundStyle(Color.pink)
            
            configuration.content
                .frame(height: height)
        }
        .padding()
        .background(Material.thin)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    BasicInfoCardView(value: "1098", title: "Title", unit: "Steps", icon: "shoeprints.fill", isLoading: false)
}
