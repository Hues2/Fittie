import Combine
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    var steps = CurrentValueSubject<Double?, Never>(nil)
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await healthStore.requestAuthorization(toShare: [], read: [HKQuantityType(.stepCount)])
    }
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else { return }
            let totalSteps = quantity.doubleValue(for: .count())
            self.steps.value = totalSteps
        }
        healthStore.execute(query)
    }
}
