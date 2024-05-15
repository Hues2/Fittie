import Foundation

class Constants {
    // MARK: - UI
    static let cornerRadius : CGFloat = 8
    static let sheetCornerRadius : CGFloat = 24
    static let horizontalPadding : CGFloat = 12
    static let cardHeight : CGFloat = 200
    
    // MARK: - Values
    static let numberOfDaysInChart : Int = 30
    
    // MARK: - User Defaults
    struct UserDefaults {
        static let hasSeenOnBoarding = "has_seen_onboarding"
        static let dailyStepGoal = "daily_step_goal"
    }
}
