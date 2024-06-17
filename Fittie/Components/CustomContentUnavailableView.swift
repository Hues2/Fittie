import SwiftUI

struct CustomContentUnavailableView: View {
    var icon : String = "exclamationmark.circle"
    var title : LocalizedStringKey = "not_available_title"
    let description : LocalizedStringKey
    var buttonTitle : LocalizedStringKey?
    var action : (() -> Void)?
    
    var body: some View {
        ContentUnavailableView {
            Label(
                title: { Text(title) },
                icon: { Image(systemName: icon).foregroundStyle(Color.secondaryAccent) }
            )
        } description: {
            Text(description)
                .padding(4)
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
