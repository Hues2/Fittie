import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case exercises
    case calendar
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder var label: some View {
        switch self {
        case .home:
            Label("home_tab_label", systemImage: "house.fill")
        case .exercises:
            Label("exercises_tab_label", systemImage: "dumbbell.fill")
        case .calendar:
            Label("calendar_tab_label", systemImage: "calendar")
        }
    }
    
    @ViewBuilder var destination: some View {
        switch self {
        case .home:
            HomeNavigationStack()
        case .exercises:
            Text("Exercises")
        case .calendar:
            Text("Calendar")
        }
    }
}
