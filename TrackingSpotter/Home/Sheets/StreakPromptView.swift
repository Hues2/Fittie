import SwiftUI

struct StreakPromptView: View {
    let userHasAlreadyLoggedActivity : Bool
    let action : (Bool) -> Void
    
    var body: some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 40)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private extension StreakPromptView {
    @ViewBuilder var content : some View {
        if userHasAlreadyLoggedActivity {
            activityAlreadyLoggedTitle
        } else {
            VStack(spacing: 28) {
                title
                buttons
            }
        }
    }
}

// MARK: Log activity "streak_already_logged_activity"
private extension StreakPromptView {
    var title : some View {
        Text("streak_prompt_title")
            .foregroundStyle(Color.customText)
            .font(.title)
            .fontWeight(.light)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var buttons : some View {
        HStack(spacing: 20) {
            button("streak_prompt_no", .red) {
                action(false)
            }
            button("streak_prompt_yes", .green) {
                action(true)
            }
        }
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

// MARK: Activity already logged
private extension StreakPromptView {
    @ViewBuilder var activityAlreadyLoggedTitle : some View {
        VStack {
            Text("streak_already_logged_activity") + Text(" \(Image(systemName: "flame"))")
                .foregroundStyle(Color.orange)
        }
        .foregroundStyle(Color.customText)
        .font(.title)
        .fontWeight(.light)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    StreakPromptView(userHasAlreadyLoggedActivity: true) { userHasWorkedOut in
        
    }

}
