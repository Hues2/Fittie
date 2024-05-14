import Foundation
import Combine

class StreakManager {
    var streak = CurrentValueSubject<Int, Never>(0)
    
    private let streakKey = "workout_streak"
    private let lastSavedDateKey = "previous_workout_streak_date"
    private let userDefaults = UserDefaults.standard
    
    init() {
        self.getStreak()
    }
    
    private func getStreak() {
        let savedStreak = userDefaults.integer(forKey: streakKey)
        guard !lastSavedStreakWasOverADay() else {
            self.resetStreak()
            return
        }
        self.streak.send(savedStreak)
    }
    
    func shouldShowPrompt() -> Bool {
        let savedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
        guard let savedDate else {
            return true            
        }
        let calendar = Calendar.current
        let savedDay = calendar.component(.day, from: savedDate)
        let currentDay = calendar.component(.day, from: Date())
        return (currentDay >= (savedDay + 1))
    }
    
    private func lastSavedStreakWasOverADay() -> Bool {
        let savedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
        guard let savedDate else { return true }
        let calendar = Calendar.current
        let savedDay = calendar.component(.day, from: savedDate)
        let currentDay = calendar.component(.day, from: Date())
        return currentDay >= (savedDay + 2)
    }
    
    private func resetStreak() {
        UserDefaults.standard.set(0, forKey: streakKey)
        self.streak.send(0)
    }
    
    func updateStreak(_ userHasWorkedOut : Bool) {
        let newStreak = userHasWorkedOut ? (streak.value + 1) : 0
        self.streak.send(newStreak)
        userDefaults.set(newStreak, forKey: streakKey)
        userDefaults.set(Date(), forKey: lastSavedDateKey)
    }
}
