import SwiftUI

struct StreakView: View {
    let streak : Int
    
    var body: some View {
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
        StreakView(streak: 5)            
            .frame(height: 200)
            .withCardModifier()
            .padding()
        
        Spacer()
            .frame(width: 175)
    }
}
