import SwiftUI

// Gets instantiated on app launch, inside the AppTabView
struct HomeNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.homeNavigationPath){
            // Root view --> Shows when homeNavigationPath is empty
            HomeView()
                .navigationDestination(for: HomeTabScreen.self) { screen in
                    switch screen {
                    case .weightDetailView:
                        WeightDetailView()
                    }
                }
        }        
    }
}
