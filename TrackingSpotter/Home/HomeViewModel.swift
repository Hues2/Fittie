import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var dailySteps : Int?
    @Published var dailyStepGoal : Int = 0
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Daily steps
    @Published var monthlySteps : [DailyStep] = []
    @Published private(set) var monthlyStepsAreLoading : Bool = true
    
    // Workout streak
    @Published private(set) var streak : Int = 0
    @Published var presentStreakPrompt : Bool = false
    @Published private(set) var userHasAlreadyLoggedStreak : Bool = false
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    @Injected(\.streakManager) private var streakManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.dailyStepGoal = getStepTarget()
        addSubscriptions()
        self.presentStreakPrompt = self.streakManager.shouldShowPrompt()
        self.userHasAlreadyLoggedStreak = presentStreakPrompt
    }
    
    private func addSubscriptions() {
        subscribeToStepGoal()
        subscribeToStreak()
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
    
    func subscribeToStreak() {
        self.streakManager.streak
            .sink { [weak self] streak in
                guard let self else { return }                
                self.streak = streak
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
    
    func getMonthlySteps() {
        let startDate = Calendar.current.date(byAdding: .day, value: -(Constants.numberOfDaysInChart - 1), to: Date.startOfDay)
        guard let startDate else { return }
        healthKitManager.fetchMonthlySteps(startDate: startDate) { [weak self] monthlySteps in
            guard let self else { return }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.monthlySteps = monthlySteps.sorted(by: { $0.date < $1.date })
                    self.monthlyStepsAreLoading = false
                }
            }
        }
    }
}

// MARK: - Workout Streak
extension HomeViewModel {    
    func updateStreak(_ userHasWorkedOut : Bool) {
        self.streakManager.updateStreak(userHasWorkedOut)
    }
}
