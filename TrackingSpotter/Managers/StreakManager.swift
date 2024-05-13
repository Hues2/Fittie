import Foundation
import Combine

class StreakManager {
    var streak = CurrentValueSubject<Int, Never>(0)
    var shouldShowPrompt = CurrentValueSubject<Bool, Never>(false)
    
    private let streakKey = "workout_streak"
    private let lastSavedDateKey = "previous_workout_streak_date"
    private let calendar = Calendar.current
    private let startOfToday = Calendar.current.startOfDay(for: Date())
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
        let streak = savedStreak
    }
    
    func showPrompt() {
        self.shouldShowPrompt.send(lastSavedStreakWasOverADay())
    }
    
    private func lastSavedStreakWasOverADay() -> Bool {
        let lastSavedDate = userDefaults.value(forKey: lastSavedDateKey) as? Date
        guard let lastSavedDate else { return true }
        guard let difference = calendar.dateComponents([.day], from: lastSavedDate, to: startOfToday).day else {
            return false
        }
        return difference > 1
    }
    
    private func resetStreak() {
        UserDefaults.standard.set(0, forKey: streakKey)
        self.streak.send(0)
    }
    
    func updateStreak(_ userWorkedOut : Bool) {
        var newStreak = userWorkedOut ? (streak.value + 1) : 0
        self.streak.send(newStreak)
        userDefaults.set(newStreak, forKey: streakKey)
        userDefaults.set(startOfToday, forKey: lastSavedDateKey)
    }
}
