import SwiftUI

struct ExercisesNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.exercisesNavigationPath) {
            ExercisesView()
        }
    }
}
