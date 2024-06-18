import SwiftUI

// Gets instantiated on app launch, inside the AppTabView
struct ExercisesNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.exercisesNavigationPath) {
            // Root view --> Shows when exercisesNavigationPath is empty
            ExercisesView()
                .navigationDestination(for: ExercisesTabScreen.self) { screen in
                    
                }
        }
    }
}
