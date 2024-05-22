import Foundation
import Factory

class WeightGoalManager {
    private let userDefaults = UserDefaults.standard
    
    func getWeightGoal() -> Double {
        let weightGoal = userDefaults.double(forKey: Constants.UserDefaults.weightGoal)
        return weightGoal
    }
    
    func setWeightGoal(_ weightGoal : Double) {
        userDefaults.setValue(weightGoal, forKey: Constants.UserDefaults.weightGoal)
    }
}
