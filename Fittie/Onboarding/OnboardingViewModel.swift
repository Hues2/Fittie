import Foundation
import Factory

final class OnboardingViewModel : ObservableObject {
    @Published var stepGoal : Int = Constants.defaultStepGoal
    @Published var weightGoal : Double?
    
    @Injected(\.healthKitManager) private var healthKitManager
    @Injected(\.stepGoalManager) private var stepGoalManager
    @Injected(\.weightGoalManager) private var weightGoalManager
    
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
        self.setStepGoal()
        self.setWeightGoal()
        self.setHasSeenOnboarding()
    }
    
    private func setHasSeenOnboarding() {
        UserDefaults.standard.setValue(false, forKey: Constants.UserDefaults.hasSeenOnboarding)
    }
    
    private func setStepGoal() {
        self.stepGoalManager.setStepGoal(stepGoal)
    }
    
    private func setWeightGoal() {
        self.weightGoalManager.setWeightGoal(weightGoal)
    }
    
    private func requestAuthorization() async throws {
        try await healthKitManager.requestAuthorization()
    }
}
