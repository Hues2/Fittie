import Foundation
import SwiftUI

class Constants {
    // MARK: - UI
    static let cornerRadius : CGFloat = 16
    static let headerCornerRadius : CGFloat = 28
    static let sheetCornerRadius : CGFloat = 32
    static let horizontalScrollviewPadding : CGFloat = 12
    static let paddingAboveSaveButton : CGFloat = 20
    static let cardHeight : CGFloat = 72
    static let graphCardHeight : CGFloat = 280
    static let minimumScaleFactor : CGFloat = 0.3
    static let lineSpacing : CGFloat = 4
    static let bigCardTextSize : CGFloat = 40
    static let bigTextInputTextSize : CGFloat = 50
    static let setInputTextSize : CGFloat = 30
    static let dynamicTypeSizeRange : ClosedRange<DynamicTypeSize> = .small ... .xLarge
    static let calendarLegendHeight : CGFloat = 40
    
    // MARK: - Values    
    static let defaultStepGoal : Int = 7500
    static let numberOfLoggedWeights : Int = 5
    static let numberOfCalendarFutureMonths : Int = 1
    
    // MARK: - User Defaults
    struct UserDefaults {
        static let hasSeenOnboarding = "has_seen_onboarding"
        static let installDate = "install_date"
        static let stepGoal = "step_goal"
        static let weightGoal = "weight_goal"
        static let selectedTimePeriod = "selected_time_period"
    }
}
