import Foundation
import Combine

class StreakManager {
    var streak = CurrentValueSubject<Int, Never>(0)
    var shouldShowPrompt = CurrentValueSubject<Bool, Never>(false)
    
    private let streakKey = "workout_streak"
    private let lastSavedDateKey = "previous_workout_streak_date"
    private let userDefaults = UserDefaults.standard
    
    init() {
        self.getStreak()
        self.showPrompt()
    }
    
    private func getStreak() {
        let savedStreak = userDefaults.integer(forKey: streakKey)
        guard !lastSavedStreakWasOverADay() else {
            self.resetStreak()
            return
        }
        self.streak.send(savedStreak)
    }
    
    func showPrompt() {
        self.shouldShowPrompt.send(lastSavedStreakWasOverADay())
    }
    
    private func lastSavedStreakWasOverADay() -> Bool {
        let lastSavedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
        guard let lastSavedDate, let deadlineDate = Calendar.current.date(byAdding: .day, value: 1, to: lastSavedDate) else { return true }
        return Date() > deadlineDate
    }
    
    private func resetStreak() {
        UserDefaults.standard.set(0, forKey: streakKey)
        self.streak.send(0)
    }
    
    func updateStreak(_ userWorkedOut : Bool) {
        let newStreak = userWorkedOut ? (streak.value + 1) : 0
        self.streak.send(newStreak)
        userDefaults.set(newStreak, forKey: streakKey)
        userDefaults.set(Date(), forKey: lastSavedDateKey)
    }
}
