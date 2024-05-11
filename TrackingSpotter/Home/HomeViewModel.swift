import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var steps : Int?
    @Published var stepGoal : Int = 0
    
    // Errors
    @Published var healthKitError : CustomError?
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.stepGoal = getStepTarget()
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToSteps()
        subscribeToStepGoal()
    }
}

private extension HomeViewModel {
    func subscribeToSteps() {
        self.healthKitManager.steps
            .receive(on: DispatchQueue.main)
            .sink { [weak self] steps in
                guard let self, let steps else { return }
                withAnimation {
                    self.steps = Int(steps)
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToStepGoal() {
        self.$stepGoal
            .dropFirst()
            .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
            .sink { [weak self] newStepGoal in
                guard let self else { return }
                self.setStepTarget(newStepGoal)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Steps
extension HomeViewModel {
    func requestAuthorization() async {
        do {
            try await healthKitManager.requestAuthorization()
        } catch {
            self.healthKitError = .healhKitAuthError(error.localizedDescription)
        }
    }
    
    func getTodaysSteps() {
        healthKitManager.fetchTodaySteps()
    }
    
    func getStepTarget() -> Int {
        let stepGoal = UserDefaults.standard.integer(forKey: Constants.UserDefaults.stepGoalKey)
        return (stepGoal == 0) ? 10_000 : stepGoal
    }
    
    func setStepTarget(_ newStepGoal : Int) {
        UserDefaults.standard.setValue(newStepGoal, forKey: Constants.UserDefaults.stepGoalKey)
    }
}
