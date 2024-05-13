import Foundation
import Factory

extension Container {
    // MARK: - HealthKit Manager
    var healthKitManager : Factory<HealthKitManager> {
        self { HealthKitManager() }
    }
    
    // MARK: - Streak Manager
    var streakManager : Factory<StreakManager> {
        self { StreakManager() }
    }
}
