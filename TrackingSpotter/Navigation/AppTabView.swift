import SwiftUI

struct AppTabView: View {
    @Binding var selectedTab: AppScreen?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}
