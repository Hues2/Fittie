import Combine
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await healthStore.requestAuthorization(toShare: [], read: [HKQuantityType(.stepCount), HKQuantityType(.activeEnergyBurned)])
    }
}

// MARK: Active Energy Burned
extension HealthKitManager {
    func fetchTodaysActiveEnergyBurned(_ completion : @escaping (Double) -> Void) {
        let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: .now)
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let activeEnergyBurned = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else {
                completion(0)
                return
            }
            completion(activeEnergyBurned)
        }
        
        healthStore.execute(query)
    }
}

// MARK: Step Count
extension HealthKitManager {
    func fetchTodaySteps(_ completion : @escaping (Double) -> Void) {
        let stepsCountType = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Date().startOfDay, end: .now)
        let query = HKStatisticsQuery(quantityType: stepsCountType, quantitySamplePredicate: predicate) { _, result, error in
            guard let totalSteps = result?.sumQuantity()?.doubleValue(for: .count()), error == nil else { completion(0); return }
            completion(totalSteps)
        }
        healthStore.execute(query)
    }
    
    func fetchDailySteps(startDate : Date, endDate : Date = Date(), _ completion : @escaping ([DailyStep]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result, error == nil else {
                completion([])
                return
            }
            
            var dailySteps : [DailyStep] = []
            result.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                dailySteps.append(DailyStep(date: statistics.startDate, steps: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            
            completion(dailySteps)
        }
        
        healthStore.execute(query)
    }
}
