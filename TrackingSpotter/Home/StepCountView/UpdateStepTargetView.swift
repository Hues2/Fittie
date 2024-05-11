import SwiftUI

struct UpdateStepTargetView: View {
    @Binding var stepGoal : Int
    
    var body: some View {
        VStack(spacing: 24) {
            title
            inputView
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
    }
}

private extension UpdateStepTargetView {
    var title : some View {
        Text("update_step_target_title")
            .foregroundStyle(Color.customWhite)
            .font(.title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var inputView : some View {
        HStack {
            button("minus") {
                guard stepGoal >= 200 else { return }
                self.stepGoal -= 100
            }
            
            Text("\(stepGoal)")
                .font(.title)
                .frame(maxWidth: .infinity)
            
            button("plus") {
                guard stepGoal <= 99_900 else { return }
                self.stepGoal += 100
            }
        }
    }
    
    func button(_ icon : String, _ action : @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .foregroundStyle(Color.customWhite)
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(width: 50, height: 50)
                .background(Color.accentColor)
                .clipShape(Circle())
                .frame(maxWidth: .infinity)
        }
        .buttonRepeatBehavior(.enabled)
    }
}

#Preview {
    UpdateStepTargetView(stepGoal: .constant(6000))
}
