import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var steps : Int?
    @Published var stepGoal : Int = 0
    @Published private(set) var dailySteps : [DailyStep] = []
    
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
        subscribeToStepGoal()
    }
}

private extension HomeViewModel {
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
        healthKitManager.fetchTodaySteps { [weak self] steps in
            guard let self else { return }
            DispatchQueue.main.async {
                self.steps = Int(steps)
            }
        }
    }
    
    func getStepTarget() -> Int {
        let stepGoal = UserDefaults.standard.integer(forKey: Constants.UserDefaults.stepGoalKey)
        return (stepGoal == 0) ? 10_000 : stepGoal
    }
    
    func setStepTarget(_ newStepGoal : Int) {
        UserDefaults.standard.setValue(newStepGoal, forKey: Constants.UserDefaults.stepGoalKey)
    }
    
    func getPast7DaysSteps() {
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date.startOfDay)
        guard let startDate else { return }
        healthKitManager.fetchDailySteps(startDate: startDate) { [weak self] dailySteps in
            guard let self else { return }
            DispatchQueue.main.async {
                self.dailySteps = dailySteps.sorted(by: { $0.date < $1.date })
                print("DAILY STEPS --> \(self.dailySteps)")
            }
        }
    }
}
