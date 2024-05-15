import Foundation
import Factory

class OnboardingViewModel : ObservableObject {
    @Published var stepGoal : Int = 10_000
    
    @Injected(\.healthKitManager) private var healthKitManager
    
    func setStepGoal() {
        UserDefaults.standard.setValue(stepGoal, forKey: Constants.UserDefaults.dailyStepGoal)
    }
    
    func requestAuthorization() {
        Task {
            try? await healthKitManager.requestAuthorization()
        }
    }
    
    func finishOnboarding() {
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.hasSeenOnBoarding)
    }
}
