import SwiftUI

struct HomeNavigationStack: View {
    var body: some View {
        NavigationStack() {
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
