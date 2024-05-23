import SwiftUI

struct AppTabView: View {
    @Binding var selectedTab: AppTab?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { screen in
                screen.destination
                    .tag(screen as AppTab?)
                    .tabItem { screen.label }
            }
        }
    }
}
