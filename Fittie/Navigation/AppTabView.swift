import SwiftUI

struct AppTabView: View {
    @EnvironmentObject private var router : Router
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases) { screen in
                screen.destination
                    .tag(screen as AppTab?)
                    .tabItem { screen.label }
            }
        }
    }
}
