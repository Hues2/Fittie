import SwiftUI

struct StreakView: View {
    @Binding var streak : Int
    let action : () -> Void
    
    var body: some View {
        CardView(title: "streak_title", height: Constants.cardHeight) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .onTapGesture {
                    action()
                }
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "flame")
                .padding(6)
                .foregroundStyle(Color.orange)
                .symbolEffect(.bounce, value: streak)                
        }
    }
}

// MARK: Streak View Content
private extension StreakView {
    var content : some View {
        HStack {
            Text("\(streak)")
        }
        .font(.system(size: 75))
        .foregroundStyle(Color.customText)
        .fontWeight(.black)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
    }
}

#Preview {
    HStack {
        StreakView(streak: .constant(5)) {
            
        }
        .frame(height: 200)
        .withCardModifier()
        .padding()
        
        Spacer()
            .frame(width: 175)
    }
}
