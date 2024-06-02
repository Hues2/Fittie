import SwiftUI

struct WorkoutsNavigationStack: View {
    var body: some View {
        NavigationStack {
            WorkoutsView()
        }
    }
}

#Preview {
    WorkoutsNavigationStack()
}
