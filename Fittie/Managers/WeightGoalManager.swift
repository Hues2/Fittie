import Foundation
import Factory

class WeightGoalManager {
    private let userDefaults = UserDefaults.standard
    
    func getWeightGoal() -> Double? {
        let weightGoal = userDefaults.value(forKey: Constants.UserDefaults.weightGoal) as? Double
        return weightGoal
    }
    
    func setWeightGoal(_ weightGoal : Double?) {
        guard let weightGoal else { return }
        userDefaults.setValue(weightGoal, forKey: Constants.UserDefaults.weightGoal)
    }
}
