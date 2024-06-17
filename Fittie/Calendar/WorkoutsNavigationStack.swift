import SwiftUI

struct WorkoutsNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.workoutsNavigationPath) {
            WorkoutsView()
        }
    }
}

#Preview {
    WorkoutsNavigationStack()
}
