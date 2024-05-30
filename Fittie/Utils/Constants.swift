import Foundation
import SwiftUI

class Constants {
    // MARK: - UI
    static let cornerRadius : CGFloat = 16
    static let headerCornerRadius : CGFloat = 28
    static let sheetCornerRadius : CGFloat = 32
    static let horizontalScrollviewPadding : CGFloat = 12
    static let cardHeight : CGFloat = 72
    static let graphCardHeight : CGFloat = 272
    static let minimumScaleFactor : CGFloat = 0.3
    static let lineSpacing : CGFloat = 4
    static let bigCardTextSize : CGFloat = 40
    static let bigTextInputTextSize : CGFloat = 50
    static let dynamicTypeSizeRange : ClosedRange<DynamicTypeSize> = .small ... .xxLarge
    
    // MARK: - Values    
    static let defaultStepGoal : Int = 7500
    static let numberOfLoggedWeights : Int = 5
    
    // MARK: - User Defaults
    struct UserDefaults {
        static let hasSeenOnboarding = "has_seen_onboarding"
        static let stepGoal = "step_goal"
        static let weightGoal = "weight_goal"
        static let selectedTimePeriod = "selected_time_period"
    }
}

// MARK: Exercises
extension Constants {
    static let chestExercises : [String] = [
        "Incline bench press",
        "Flat bench press",
        "Decline bench press",
    ]
    
    static let armExercises : [String] = [
        "Bicep curl",
    ]
    
    static let shoulderExercises : [String] = [
        "Lateral raise"
    ]
    
    static let backExercises : [String] = [
        "Lat pulldown"
    ]
    
    static let legExercises : [String] = [
        "Squats",
        "Leg extension"
    ]        
}
