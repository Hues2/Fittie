import SwiftUI

struct CalendarNavigationStack: View {
    var body: some View {
        NavigationStack {
            CalendarView()
        }
    }
}

#Preview {
    CalendarNavigationStack()
}
