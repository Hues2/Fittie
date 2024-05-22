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
