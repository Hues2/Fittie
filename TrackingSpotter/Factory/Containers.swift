import Foundation
import Factory

extension Container {
    // MARK: - HealthKit Manager
    var healthKitManager : Factory<HealthKitManager> {
        self { HealthKitManager() }
    }
    
    // MARK: - Step Goal Manager
    var stepGoalManager : Factory<StepGoalManager> {
        self { StepGoalManager() }
    }
}
