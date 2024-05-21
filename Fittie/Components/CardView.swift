import SwiftUI

struct CardView<CardContent : View> : View {
    let icon : String
    let title : LocalizedStringKey
    let height : CGFloat
    let cardContent : CardContent
    
    init(icon : String, title: LocalizedStringKey, height: CGFloat, @ViewBuilder cardContent: () -> CardContent) {
        self.icon = icon
        self.title = title
        self.height = height
        self.cardContent = cardContent()        
    }
    
    var body: some View {
        GroupBox {
            cardContent
                .frame(maxWidth: .infinity)
        } label: {
            Text(title)
        }
        .groupBoxStyle(HomeCardGroupBoxStyle(height: height, icon: icon))
    }
    
    func sectionTitle(_ title : LocalizedStringKey) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.thin)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DailyStepCountView(steps: 1025, isLoading: false)
}
