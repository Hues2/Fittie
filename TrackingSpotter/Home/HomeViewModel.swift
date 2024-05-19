import SwiftUI
import Combine
import Factory

class HomeViewModel : ObservableObject {
    // Todays Steps
    @Published private(set) var todaysSteps : Int?
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Number of daily step goals achieved
    @Published var stepGoal : Int = 0
    @Published private(set) var achievedStepGoals : Int = 0
    @Published private(set) var achievedStepGoalsIsLoading : Bool = true
    
    // Step Chart
    @Published var chartSteps : [DailyStep] = []
    @Published private var montlhySteps : [DailyStep] = []
    @Published private var weeklySteps : [DailyStep] = []
    @Published var stepsAreLoading : Bool = true
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
        subscribeToSelectedTimePeriod()
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
    
    func subscribeToSelectedTimePeriod() {
        self.$selectedPeriod
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] selectedTimePeriod in
                guard let self else { return }
                self.setChartSteps(selectedTimePeriod)
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
                    self.todaysSteps = Int(steps)
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
                    // This is to set the chart steps list for the first time (on app launch)
                    self.setChartSteps(self.selectedPeriod)
                    self.stepsAreLoading = false
                }
            }
        }
    }
    
    func getAchievedStepGoals() {
        self.stepGoalManager.getNumberOfDailyStepGoalsAchieved { achievedStepGoals in
            DispatchQueue.main.async {
                withAnimation {
                    self.achievedStepGoals = achievedStepGoals
                    self.achievedStepGoalsIsLoading = false
                }
            }
        }
    }
    
    private func setChartSteps(_ selectedTimePeriod : TimePeriod) {
        switch selectedTimePeriod {
        case .month:
            self.chartSteps = self.montlhySteps
        case .week:
            self.chartSteps = self.weeklySteps
        }
    }
}
