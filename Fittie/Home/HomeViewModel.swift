import SwiftUI
import Combine
import Factory

final class HomeViewModel : ObservableObject {
    // Todays Steps
    @Published private(set) var todaysSteps : Int = 0
    @Published private(set) var dailyStepsAreLoading : Bool = true
    
    // Number of daily step goals achieved
    @Published var stepGoal : Int = .zero
    
    // Step Chart
    @Published var chartSteps : [DailyStep] = []
    @Published private var montlhySteps : [DailyStep] = []
    @Published private var weeklySteps : [DailyStep] = []
    @Published var stepsAreLoading : Bool = true
    @Published var selectedPeriod : TimePeriod = .month
    
    // Active Burned Energy
    @Published var activeBurnedEnergy : Double = .zero
    @Published private(set) var burnedEnergyIsLoading : Bool = true
    
    // Weight
    @Published var weightGoal : Double?
    
    // Dependencies
    @Injected(\.healthKitManager) private var healthKitManager
    @Injected(\.stepGoalManager) private var stepGoalManager
    @Injected(\.weightGoalManager) private var weightGoalManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.stepGoal = getStepGoal()
        self.selectedPeriod = getSelectedTimePeriod()
        addSubscriptions()
        
        // Fetch the needed data
        getStepsForTimePeriod()
        getWeightGoal()
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
                self.saveSelectedTimePeriod()
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
    
    private func setChartSteps(_ selectedTimePeriod : TimePeriod) {
        switch selectedTimePeriod {
        case .month:
            self.chartSteps = self.montlhySteps
        case .week:
            self.chartSteps = self.weeklySteps
        }
    }
}
// MARK: Active Energy Burned
extension HomeViewModel {
    func getActiveBurnedEnergy() {
        healthKitManager.fetchTodaysActiveEnergyBurned { [weak self] kilocalories in
            guard let self else { return }
            DispatchQueue.main.async {
                withAnimation {
                    self.activeBurnedEnergy = kilocalories
                    self.burnedEnergyIsLoading = false
                }
            }
        }
    }
}

// MARK: Selected Time Period
private extension HomeViewModel {
    func getSelectedTimePeriod() -> TimePeriod {
        let savedTimePeriodRawValue = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedTimePeriod) as? String
        guard let savedTimePeriodRawValue, let timePeriod = TimePeriod(rawValue: savedTimePeriodRawValue) else { return .week }
        return timePeriod
    }
    
    func saveSelectedTimePeriod() {
        UserDefaults.standard.setValue(self.selectedPeriod.rawValue, forKey: Constants.UserDefaults.selectedTimePeriod)
    }
}

// MARK: Weight Goal
private extension HomeViewModel {
    func getWeightGoal() {
        self.weightGoal = weightGoalManager.getWeightGoal()
    }
}
