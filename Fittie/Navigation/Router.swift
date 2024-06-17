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
        self.selectedTab = .workouts
    }
    
    func routeToExercisesTab() {
        self.selectedTab = .exercises
    }
}

// MARK: Home Navigation
extension Router {
    
}

// MARK: Workouts Navigation
extension Router {
    func routeToAddFirstWorkout() {
        self.routeToWorkoutsTab()
        self.workoutsNavigationPath.append(.addFirstWorkout)
    }
}

// MARK: Exercises Navigation
extension Router {
    
}
