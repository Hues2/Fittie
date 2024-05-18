import Foundation
import Combine
import Factory

class StepGoalManager {
    var achievedStepGoals = CurrentValueSubject<Int, Never>(0)
    
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
    func getNumberOfDailyStepGoalsAchieved() {
        let installDate = userDefaults.value(forKey: Constants.UserDefaults.installDate) as? Date ?? Date().startOfDay
        self.healthKitManager.fetchDailySteps(startDate: installDate, endDate: Date()) { [weak self] dailySteps in
            guard let self else { return }            
            let stepGoalsAchieved = dailySteps.filter({ $0.steps > self.getStepGoal() }).count
            self.achievedStepGoals.send(stepGoalsAchieved)
        }
    }
}
