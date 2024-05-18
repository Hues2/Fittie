import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var dailySteps : Int?
    @Published var stepGoal : Int = 0
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Daily steps
    @Published var monthlySteps : [DailyStep] = []
    @Published private(set) var monthlyStepsAreLoading : Bool = true
    
    // Number of daily step goals achieved
    @Published private(set) var achievedStepGoals : Int = 0
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    @Injected(\.stepGoalManager) private var stepGoalManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.stepGoal = getStepGoal()
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToStepGoal()
        subscribeTonumberOfDailyStepGoalsAchieved()
    }
}

private extension HomeViewModel {
    func subscribeToStepGoal() {
        self.$stepGoal
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .debounce(for: .seconds(0.75), scheduler: DispatchQueue.main)
            .sink { [weak self] newStepGoal in
                guard let self else { return }
                self.setStepGoal(newStepGoal)
            }
            .store(in: &cancellables)
    }
    
    func subscribeTonumberOfDailyStepGoalsAchieved() {
        self.stepGoalManager.achievedStepGoals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] achievedStepGoals in
                guard let self else { return }
                self.achievedStepGoals = achievedStepGoals
            }
            .store(in: &cancellables)
    }
}

// MARK: - Steps
extension HomeViewModel {
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
    
    private func getStepGoal() -> Int {
        self.stepGoalManager.getStepGoal()
    }
    
    func setStepGoal(_ newStepGoal : Int) {
        self.stepGoalManager.setStepGoal(newStepGoal)
    }
    
    func getMonthlySteps() {
        let startDate = Calendar.current.date(byAdding: .day, value: -(Constants.numberOfDaysInChart - 1), to: Date().startOfDay)
        guard let startDate else { return }
        healthKitManager.fetchDailySteps(startDate: startDate) { [weak self] monthlySteps in
            guard let self else { return }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.monthlySteps = monthlySteps.sorted(by: { $0.date < $1.date })
                    self.monthlyStepsAreLoading = false
                }
            }
        }
    }
    
    func getAchievedStepGoals() {
        self.stepGoalManager.getNumberOfDailyStepGoalsAchieved()
    }
}
