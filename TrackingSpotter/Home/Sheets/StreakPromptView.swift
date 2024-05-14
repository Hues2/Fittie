import SwiftUI

struct StreakPromptView: View {
    let action : (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 28) {
            title
            HStack {
                button("streak_prompt_no", .red) {
                    action(false)
                }
                button("streak_prompt_yes", .green) {
                    action(true)
                }
            }
        }
    }
}

private extension StreakPromptView {
    var title : some View {
        Text("streak_prompt_title")
            .foregroundStyle(Color.customText)
            .font(.title)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func button(_ title : LocalizedStringKey, _ color : Color, _ action : @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(Color.cardBackground)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }

    }
}

#Preview {
    StreakPromptView { userHasWorkedOut in
        
    }

}
