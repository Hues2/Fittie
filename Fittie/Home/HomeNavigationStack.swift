import SwiftUI

struct HomeNavigationStack: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        NavigationStack(path: $router.homeNavigationPath){
            HomeView()
                .navigationDestination(for: HomeTabScreen.self) { screen in
                    switch screen {
                    case .rootView:
                        HomeView()
                    case .weightDetailView:
                        WeightDetailView()
                    }
                }
        }        
    }
}
