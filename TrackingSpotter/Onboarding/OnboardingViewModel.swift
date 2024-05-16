import Foundation
import Factory

class OnboardingViewModel : ObservableObject {
    @Published var stepGoal : Int = Constants.defaultStepGoal
    
    @Injected(\.healthKitManager) private var healthKitManager
    
    func setPermissions(_ completion : @escaping () -> Void) {
        Task {
            do {
                try await self.requestAuthorization()
                completion()
            } catch {
                completion()
            }
        }
    }
    
    func finishOnboarding() {
        self.setHasSeenOnboarding()
        self.setStepGoal()
    }
    
    private func setHasSeenOnboarding() {
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.hasSeenOnboarding)
    }
    
    private func setStepGoal() {
        UserDefaults.standard.setValue(stepGoal, forKey: Constants.UserDefaults.dailyStepGoal)
    }
    
    private func requestAuthorization() async throws {
        try await healthKitManager.requestAuthorization()
    }
}
