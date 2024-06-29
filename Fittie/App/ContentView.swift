import SwiftUI

struct ContentView: View {
    @StateObject private var router : Router = Router()
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
        Color.background
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true), content: {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .interactiveDismissDisabled(true)
                    .presentationCornerRadius(Constants.sheetCornerRadius)
            })
    }
}
