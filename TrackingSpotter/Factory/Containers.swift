import Foundation
import Factory

extension Container {
    var healthKitManager: Factory<HealthKitManager> {
        self { HealthKitManager() }
    }
}
