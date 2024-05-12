import SwiftUI

struct StreakView: View {
    let streak : Int
    
    var body: some View {
        HStack {
            Text("\(streak)")
            Text("🔥")
        }
        .font(.largeTitle)
        .foregroundStyle(Color.customText)
        .fontWeight(.black)
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
