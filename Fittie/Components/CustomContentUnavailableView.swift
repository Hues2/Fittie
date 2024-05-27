import SwiftUI

struct CustomContentUnavailableView: View {
    var title : LocalizedStringKey = "not_available_title"
    let description : LocalizedStringKey
    var buttonTitle : LocalizedStringKey?
    var action : (() -> Void)?
    
    var body: some View {
        ContentUnavailableView {
            Label(
                title: { Text(title) },
                icon: { Image(systemName: "exclamationmark.circle").foregroundStyle(.pink) }
            )
        } description: {
            Text(description)
        } actions: {
            if let buttonTitle, let action {
                Button {
                    action()
                } label: {
                    Text(buttonTitle)
                        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
            }
        }
    }
}

#Preview {
    CustomContentUnavailableView(title: "not_available_title", description: "Log your current weight to get started")
}
