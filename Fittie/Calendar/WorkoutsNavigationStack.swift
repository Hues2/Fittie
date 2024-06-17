import SwiftUI

struct WorkoutsNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.workoutsNavigationPath) {
            WorkoutsView()
                .navigationDestination(for: WorkoutsTabScreen.self) { screen in
                    switch screen {
                    case .rootView:
                        WorkoutsView()
                    case .addFirstWorkout:
                        WorkoutsView(selectedCalendarDate: CalendarDate(date: .now.startOfDay, workout: nil))
                    }
                }
        }
    }
}
