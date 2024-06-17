import SwiftUI

struct ContentView: View {
    @StateObject private var router : Router = Router()
    @State private var presentOnboarding : Bool = false
    @State private var hasSeenOnboarding : Bool = UserDefaults.standard.bool(forKey: Constants.UserDefaults.hasSeenOnboarding)
    
    var body: some View {
        if  !hasSeenOnboarding {
            onBoardingView
        } else {
            AppTabView()
                .environmentObject(router)
        }
    }
}

private extension ContentView {
    var onBoardingView : some View {
        Color.clear
            .ignoresSafeArea()
            .onAppear {
                self.presentOnboarding = true                
            }
            .sheet(isPresented: $presentOnboarding, content: {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .interactiveDismissDisabled(true)
                    .presentationCornerRadius(Constants.sheetCornerRadius)
            })
    }
}
