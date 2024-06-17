import Foundation

final class Router : ObservableObject {
    @Published var selectedTab: AppTab = .home
}

// MARK: Change tabs
extension Router {
    func routeToHomeTab() {
        self.selectedTab = .home
    }
    
    func routeToCalendarTab() {
        self.selectedTab = .calendar
    }
    
    func routeToExercisesTab() {
        self.selectedTab = .exercises
    }
}
