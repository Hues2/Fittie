import Foundation
import Factory

class WeightDetailViewModel : ObservableObject {
    @Published var weightGoal : Double?
    
    @Injected(\.weightGoalManager) private var weightGoalManager
    
    init() {
        self.getWeightGoal()
    }
}

// MARK: Weight Goal
private extension WeightDetailViewModel {
    func getWeightGoal() {
        self.weightGoal = weightGoalManager.getWeightGoal()
    }
}
