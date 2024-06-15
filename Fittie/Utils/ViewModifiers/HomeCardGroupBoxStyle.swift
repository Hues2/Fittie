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
            .foregroundStyle(Constants.Colors.secondaryAccent)
            
            configuration.content
                .frame(height: height)
        }
        .padding()
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

#Preview {
    BasicInfoCardView(value: "1098", title: "Title", unit: "Steps", icon: "shoeprints.fill", isLoading: false)
}
