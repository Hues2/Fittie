import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppScreen? = .home
    @State private var presentOnboarding : Bool = false
    private let hasSeenOnboarding = UserDefaults.standard.bool(forKey: Constants.UserDefaults.hasSeenOnBoarding)
    
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
                OnboardingView()
                    .interactiveDismissDisabled(true)
            })
    }
}
