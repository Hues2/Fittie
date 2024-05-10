import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppScreen? = .home
    
    var body: some View {
        AppTabView(selectedTab: $selectedTab)
    }
}
