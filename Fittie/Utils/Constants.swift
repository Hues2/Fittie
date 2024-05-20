import Foundation
import SwiftUI

class Constants {
    // MARK: - UI
    static let cornerRadius : CGFloat = 8
    static let sheetCornerRadius : CGFloat = 28
    static let horizontalPadding : CGFloat = 12
    static let cardHeight : CGFloat = 150
    static let graphCardHeight : CGFloat = 275
    static let minimumScaleFactor : CGFloat = 0.3
    static let lineSpacing : CGFloat = 2
    static let bigTextSize : CGFloat = 50
    static let dynamicTypeSizeRange : ClosedRange<DynamicTypeSize> = .small ... .xxLarge
    
    // MARK: - Values
    static let numberOfDaysInChart : Int = 30
    static let defaultStepGoal : Int = 7500
    
    // MARK: - User Defaults
    struct UserDefaults {
        static let hasSeenOnboarding = "has_seen_onboarding"
        static let stepGoal = "step_goal"
        static let installDate = "install_date"
        static let selectedTimePeriod = "selected_time_period"
    }
}