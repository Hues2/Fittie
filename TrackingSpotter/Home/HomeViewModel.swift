import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Steps
    @Published private(set) var dailySteps : Int?
    @Published var stepGoal : Int = 0
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Number of daily step goals achieved
    @Published private(set) var achievedStepGoals : Int = 0
    @Published private(set) var achievedStepGoalsIsLoading : Bool = true
    
    // Step Chart
    @Published var stepsAreLoading : Bool = true
    @Published var montlhySteps : [DailyStep] = []
    @Published var weeklySteps : [DailyStep] = []
    @Published var selectedPeriod : TimePeriod = .month
    
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    @Injected(\.stepGoalManager) private var stepGoalManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.stepGoal = getStepGoal()
        addSubscriptions()
        
        // Fetch the needed data
        getDailySteps()
        getAchievedStepGoals()
        getStepsForTimePeriod()
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
                self.achievedStepGoalsIsLoading = false
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
    
    func getStepsForTimePeriod(_ selectedPeriod : TimePeriod = .month) {
        let startDate = Calendar.current.date(byAdding: .day, value: -(selectedPeriod.numberOfDays - 1), to: Date().startOfDay)
        guard let startDate else { return }
        healthKitManager.fetchDailySteps(startDate: startDate) { [weak self] steps in
            guard let self else { return }
                
            DispatchQueue.main.async {
                withAnimation {
                    let steps = steps.sorted(by: { $0.date < $1.date })
                    let weeklySteps = Array(steps.suffix(TimePeriod.week.numberOfDays))
                    
                    self.montlhySteps = steps
                    self.weeklySteps = weeklySteps
                    self.stepsAreLoading = false
                }
            }
        }
    }
    
    func getAchievedStepGoals() {
        self.stepGoalManager.getNumberOfDailyStepGoalsAchieved()
    }
}
