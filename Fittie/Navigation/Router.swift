import Foundation

final class Router : ObservableObject {
    @Published var selectedTab: AppTab = .home
    
    // Tab navigation paths
    @Published var homeNavigationPath : [HomeTabScreen] = []
    @Published var workoutsNavigationPath : [WorkoutsTabScreen] = []
    @Published var exercisesNavigationPath : [ExercisesTabScreen] = []
}

// MARK: Change tabs
extension Router {
    func routeToHomeTab() {
        self.selectedTab = .home
    }
    
    func routeToWorkoutsTab() {
        self.selectedTab = .calendar
    }
    
    func routeToExercisesTab() {
        self.selectedTab = .exercises
    }
}
