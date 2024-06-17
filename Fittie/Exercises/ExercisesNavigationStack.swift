import SwiftUI

struct ExercisesNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.exercisesNavigationPath) {
            ExercisesView()
                .navigationDestination(for: ExercisesTabScreen.self) { screen in
                    switch screen {
                    case .rootView:
                        ExercisesView()
                    }
                }
        }
    }
}
