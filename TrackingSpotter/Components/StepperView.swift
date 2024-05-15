import SwiftUI

struct StepperView: View {
    @Binding var stepGoal : Int
    
    var body: some View {
        inputView
    }
    
    var inputView : some View {
        HStack {
            button("minus", (stepGoal == 100)) {
                guard stepGoal >= 200 else { return }
                self.stepGoal -= 100
            }
            
            Text("\(stepGoal)")
                .font(.title)
                .frame(maxWidth: .infinity)
            
            button("plus", (stepGoal == 100_000)) {
                guard stepGoal <= 99_900 else { return }
                self.stepGoal += 100
            }
        }
    }
    
    func button(_ icon : String, _ isDisabled : Bool, _ action : @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .foregroundStyle(Color.cardBackground)
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(width: 50, height: 50)
                .background(isDisabled ? Color.lightGray : Color.accentColor)
                .clipShape(Circle())
                .frame(maxWidth: .infinity)
                .contentShape(Circle())
        }
        .buttonRepeatBehavior(.enabled)
    }
}

#Preview {
    StepperView(stepGoal: .constant(10_000))
}
