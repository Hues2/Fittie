import Foundation
import Factory

class StepGoalManager {
    private let userDefaults = UserDefaults.standard
    
    @Injected(\.healthKitManager) private var healthKitManager
}

// MARK: Step Goal
extension StepGoalManager {
    func getStepGoal() -> Int {
        let stepGoal = userDefaults.integer(forKey: Constants.UserDefaults.stepGoal)
        return ((stepGoal <= 0) ? Constants.defaultStepGoal : stepGoal)
    }
    
    func setStepGoal(_ stepGoal : Int) {
        userDefaults.setValue(stepGoal, forKey: Constants.UserDefaults.stepGoal)
    }
}

// MARK: Number of daily step goals achieved
extension StepGoalManager {
    func getNumberOfDailyStepGoalsAchieved(_ completion : @escaping (Int) -> Void) {
        let installDate = userDefaults.value(forKey: Constants.UserDefaults.installDate) as? Date ?? Date().startOfDay
        self.healthKitManager.fetchDailySteps(startDate: installDate, endDate: Date()) { [weak self] dailySteps in
            guard let self else { return }            
            let stepGoalsAchieved = dailySteps.filter({ $0.steps > self.getStepGoal() }).count
            completion(stepGoalsAchieved)
        }
    }
}
