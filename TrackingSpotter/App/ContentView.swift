import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppScreen? = .home
    @State private var presentOnboarding : Bool = false
    @State private var hasSeenOnboarding : Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaults.hasSeenOnboarding)
    
    var body: some View {
        if  !hasSeenOnboarding {
            onBoardingView
        } else {
            AppTabView(selectedTab: $selectedTab)
        }
    }
}

private extension ContentView {
    var onBoardingView : some View {
        Color.customBackground
            .ignoresSafeArea()
            .onAppear {
                self.presentOnboarding = true                
            }
            .sheet(isPresented: $presentOnboarding, content: {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .interactiveDismissDisabled(true)
            })
    }
}
