import SwiftUI

enum AppTab: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case workouts
    case exercises
    
    var id: AppTab { self }
}

extension AppTab {
    @ViewBuilder var label: some View {
        switch self {
        case .home:
            Label("home_tab_label", systemImage: "house.fill")
        case .workouts:
            Label("workouts_tab_label", systemImage: "calendar")
        case .exercises:
            Label("exercises_tab_label", systemImage: "dumbbell.fill")
        }
    }
    
    @ViewBuilder var destination: some View {
        switch self {
        case .home:
            HomeNavigationStack()
        case .workouts:
            WorkoutsNavigationStack()
        case .exercises:
            ExercisesNavigationStack()
        }
    }
}
