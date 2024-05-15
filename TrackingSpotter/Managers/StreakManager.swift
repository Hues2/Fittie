import Foundation
import Combine
import Factory

class StreakManager {
    var streak = CurrentValueSubject<Int, Never>(0)
    
    private let streakKey = "step_streak"
    private let lastSavedDateKey = "last_saved_date"
    private let dailyStepGoalKey = Constants.UserDefaults.dailyStepGoalKey
    private let userDefaults = UserDefaults.standard
    
    @Injected(\.healthKitManager) private var healthKitManager
    
    func performDailyStreakCheck() {
        // Always fetch the current streak for the UI
        getStreak()
                
        let today = Date().startOfDay
        let yesterday = Date.getDayFrom(date: today, days: -1)
        var currentStreak = userDefaults.integer(forKey: streakKey)
        let dailyStepGoal = userDefaults.integer(forKey: dailyStepGoalKey)
        guard let yesterday else { return }
        
        // 1. Get the last saved date. If there is none, then use yesterday's date
        let savedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date ?? yesterday
//        let savedDate = Date.daysBefore(date: today, days: -3)! //--> This can be used to test
        // 2. Check if this has already been performed today, by checking if the last saved date == today
        guard !savedDate.isSameDay(as: today) else { return }
        
        // 3. Perform a query with the start of the last saved date and the start of todays date
        self.healthKitManager.fetchDailySteps(startDate: savedDate, endDate: yesterday) { [weak self] dailySteps in
            guard let self else { return }
         
            // 4. In the results handler, check the step count of each day. If the step count is >= than the step goal then add one to the streak. If not then set the streak to 0
            for dailyStep in dailySteps.sorted(by: { $0.date < $1.date }) {
                print("DAILY STEP: \(dailyStep.date.formatted()) --> \(dailyStep.steps)")
                if dailyStep.steps >= dailyStepGoal {
                    currentStreak += 1
                } else {
                    currentStreak = 0
                }
            }
            self.streak.send(currentStreak)
            
            // 5. Save todays date as the last saved date
            userDefaults.set(Date(), forKey: lastSavedDateKey)
            userDefaults.setValue(currentStreak, forKey: streakKey)
        }
    }
    
    private func getStreak() {
        let savedStreak = userDefaults.integer(forKey: streakKey)
        self.streak.send(savedStreak)
    }
    
    private func resetStreak() {
        UserDefaults.standard.set(0, forKey: streakKey)
        self.streak.send(0)
    }
}


//class StreakManager {
//    var streak = CurrentValueSubject<Int, Never>(0)
//    
//    private let streakKey = "workout_streak"
//    private let lastSavedDateKey = "previous_workout_streak_date"
//    private let userDefaults = UserDefaults.standard
//    
//    init() {
//        self.getStreak()
//    }
//    
//    private func getStreak() {
//        let savedStreak = userDefaults.integer(forKey: streakKey)
//        guard !lastSavedStreakWasOverADay() else {
//            self.resetStreak()
//            return
//        }
//        self.streak.send(savedStreak)
//    }
//    
//    func shouldShowPrompt() -> Bool {
//        let savedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
//        guard let savedDate else {
//            return true            
//        }
//        let calendar = Calendar.current
//        let savedDay = calendar.component(.day, from: savedDate)
//        let currentDay = calendar.component(.day, from: Date())
//        return (currentDay >= (savedDay + 1))
//    }
//    
//    private func lastSavedStreakWasOverADay() -> Bool {
//        let savedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
//        guard let savedDate else { return true }
//        let calendar = Calendar.current
//        let savedDay = calendar.component(.day, from: savedDate)
//        let currentDay = calendar.component(.day, from: Date())
//        return currentDay >= (savedDay + 2)
//    }
//    
//    private func resetStreak() {
//        UserDefaults.standard.set(0, forKey: streakKey)
//        self.streak.send(0)
//    }
//    
//    func updateStreak(_ userHasWorkedOut : Bool) {
//        let newStreak = userHasWorkedOut ? (streak.value + 1) : 0
//        self.streak.send(newStreak)
//        userDefaults.set(newStreak, forKey: streakKey)
//        userDefaults.set(Date(), forKey: lastSavedDateKey)
//    }
//}
