import SwiftUI

struct HomeCardGroupBoxStyle : GroupBoxStyle {
    let height : CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
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
    DailyStepCountView(steps: 1025, isLoading: false)
}
