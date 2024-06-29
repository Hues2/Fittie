import SwiftUI

// Gets instantiated on app launch, inside the AppTabView
struct WorkoutsNavigationStack: View {
    @EnvironmentObject private var router : Router
    @StateObject private var viewModel = WorkoutsViewModel()
    
    var body: some View {
        NavigationStack(path: $router.workoutsNavigationPath) {
            // Root view --> Shows when workoutsNavigationPath is empty
            WorkoutsView(viewModel: viewModel)
                .navigationDestination(for: WorkoutsTabScreen.self) { screen in
                    
                }
        }
        .sheet(item: $viewModel.selectedCalendarDate) { calendarDate in
            AddWorkoutView(calendarDate: calendarDate)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(Constants.sheetCornerRadius)
        }
        .onChange(of: router.addFirstWorkoutToggle) { _, _ in
            // This shows the add workout sheet for todays date
            // This will run when the user taps on the "Log your first workout" from the exercises view
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.viewModel.selectedCalendarDate = CalendarDate(date: .now.startOfDay, workout: nil)
            }
        }
    }
}
