import SwiftUI

struct InputTitle: View {
    let title : LocalizedStringKey
    let showBackButton : Bool
    let backAction : () -> Void
    
    var body: some View {
        Button {
            backAction()
        } label: {
            HStack {
                if showBackButton {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                }
                Text(title)                    
            }
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!showBackButton)
    }
}

#Preview {
    InputTitle(title: "Hello", showBackButton: true) { }
}
