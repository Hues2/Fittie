import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var dailySteps : Int?
    @Published var dailyStepGoal : Int = 0
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Daily steps
    @Published var weeklySteps : [DailyStep] = []
    @Published private(set) var weeklyStepsAreLoading : Bool = true
    
    // Workout streak
    @Published var workoutStreak : Int = 0
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.dailyStepGoal = getStepTarget()
        self.workoutStreak = getWorkoutStreak()
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToStepGoal()
    }
}

private extension HomeViewModel {
    func subscribeToStepGoal() {
        self.$dailyStepGoal
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
        try? await healthKitManager.requestAuthorization()
    }
    
    func getDailySteps() {
        healthKitManager.fetchTodaySteps { [weak self] steps in
            guard let self else { return }
            DispatchQueue.main.async {
                withAnimation {
                    self.dailySteps = Int(steps)
                    self.dailyStepsAreLoading = false
                }
            }
        }
    }
    
    private func getStepTarget() -> Int {
        let stepGoal = UserDefaults.standard.integer(forKey: Constants.UserDefaults.dailyStepGoalKey)
        return (stepGoal == 0) ? 10_000 : stepGoal
    }
    
    func setStepTarget(_ newStepGoal : Int) {
        UserDefaults.standard.setValue(newStepGoal, forKey: Constants.UserDefaults.dailyStepGoalKey)
    }
    
    func getWeeklySteps() {
        let startDate = Calendar.current.date(byAdding: .day, value: -(Constants.numberOfDaysInChart - 1), to: Date.startOfDay)
        guard let startDate else { return }
        healthKitManager.fetchDailySteps(startDate: startDate) { [weak self] weeklySteps in
            guard let self else { return }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.weeklySteps = weeklySteps.sorted(by: { $0.date < $1.date })
                    self.weeklyStepsAreLoading = false
                }
            }
        }
    }
}

// MARK: - Workout Streak
extension HomeViewModel {
    private func getWorkoutStreak() -> Int {
        UserDefaults.standard.integer(forKey: Constants.UserDefaults.workoutStreak)
    }
}
