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
                }
                Text(title)                    
            }
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    InputTitle(title: "Hello", showBackButton: true) { }
}
