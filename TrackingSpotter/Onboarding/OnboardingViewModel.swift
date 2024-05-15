import Foundation
import Factory

class OnboardingViewModel : ObservableObject {
    @Published var stepGoal : Int = 10_000
    
    @Injected(\.healthKitManager) private var healthKitManager
    
    func finishOnboarding(_ dismiss : @escaping () -> Void) {
        self.setHasSeenOnboarding()
        self.setStepGoal()
        Task {
            do {
                try await self.requestAuthorization()
                dismiss()
            } catch {
                dismiss()
            }
        }
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
