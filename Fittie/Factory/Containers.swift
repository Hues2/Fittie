import Foundation
import Factory

extension Container {
    // MARK: - HealthKit Manager
    var healthKitManager : Factory<HealthKitManager> {
        self { HealthKitManager() }
            .singleton
    }
    
    // MARK: - Step Goal Manager
    var stepGoalManager : Factory<StepGoalManager> {
        self { StepGoalManager() }
            .singleton
    }
    
    // MARK: - Weight Goal Manager
    var weightGoalManager : Factory<WeightGoalManager> {
        self { WeightGoalManager() }
            .singleton
    }
}
