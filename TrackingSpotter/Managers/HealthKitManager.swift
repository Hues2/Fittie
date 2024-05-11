import Combine
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await healthStore.requestAuthorization(toShare: [], read: [HKQuantityType(.stepCount)])
    }
    
    func fetchTodaySteps(_ completion : @escaping (Double) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Date.startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let totalSteps = result?.sumQuantity()?.doubleValue(for: .count()), error == nil else { return }
            completion(totalSteps)
        }
        healthStore.execute(query)
    }
    
    func fetchDailySteps(startDate : Date, _ completion : @escaping ([Date : Double]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result else {
                completion([:])
                return
            }
            
            var dailySteps : [Date : Double] = [:]
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps[statistics.endDate] = statistics.sumQuantity()?.doubleValue(for: .count())
            }
            
            completion(dailySteps)
        }
        
        healthStore.execute(query)
    }
}
