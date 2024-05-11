import SwiftUI

struct CustomContentUnavailableView: View {
    var body: some View {
        ContentUnavailableView {
            Label(
                title: { Text("Not Available") },
                icon: { Image(systemName: "exclamationmark.circle") }
            )
        } description: {
            Text("Can't retrieve your steps")
        }
    }
}
