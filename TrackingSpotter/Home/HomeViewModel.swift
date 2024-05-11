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
    }
}

private extension HomeViewModel {
    func subscribeToSteps() {
        self.healthKitManager.steps
            .receive(on: DispatchQueue.main)
            .sink { steps in
                guard let steps else { return }
                withAnimation {
                    self.steps = Int(steps)
                }
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
        let stepGoal = UserDefaults.standard.integer(forKey: Constants.UserDefaults.stepTargetKey)
        return (stepGoal == 0) ? 10_000 : stepGoal
    }
    
    func setStepTarget() {
        
    }
}
