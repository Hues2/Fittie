import Foundation
import SwiftUI

class Constants {
    // MARK: - UI
    static let cornerRadius : CGFloat = 16
    static let headerCornerRadius : CGFloat = 28
    static let sheetCornerRadius : CGFloat = 32
    static let horizontalScrollviewPadding : CGFloat = 12
    static let paddingAboveSaveButton : CGFloat = 36
    static let cardHeight : CGFloat = 72
    static let graphCardHeight : CGFloat = 272
    static let minimumScaleFactor : CGFloat = 0.3
    static let lineSpacing : CGFloat = 4
    static let bigCardTextSize : CGFloat = 40
    static let bigTextInputTextSize : CGFloat = 50
    static let setInputTextSize : CGFloat = 30
    static let dynamicTypeSizeRange : ClosedRange<DynamicTypeSize> = .small ... .xxLarge
    static let backgroundMaterial : Material = .ultraThickMaterial
    static let backgroundLightMaterial : Material = .ultraThinMaterial
    
    // MARK: - Values    
    static let defaultStepGoal : Int = 7500
    static let numberOfLoggedWeights : Int = 5
    
    // MARK: - User Defaults
    struct UserDefaults {
        static let hasSeenOnboarding = "has_seen_onboarding"
        static let installDate = "install_date"
        static let stepGoal = "step_goal"
        static let weightGoal = "weight_goal"
        static let selectedTimePeriod = "selected_time_period"
    }
}

// MARK: Exercises
extension Constants {
    static let chestExercises : [String] = [
        "Bench Press",
        "Incline Bench Press",
        "Decline Bench Press",
        "Chest Flyes",
        "Chest Dips",
        "Push-Ups",
        "Dumbbell Bench Press",
        "Incline Dumbbell Bench Press",
        "Decline Dumbbell Bench Press",
        "Cable Crossovers",
        "Pec Deck Machine",
        "Smith Machine Bench Press",
        "Incline Smith Machine Bench Press",
        "Decline Smith Machine Bench Press"
    ]
    
    static let armExercises : [String] = [
        "Barbell Curls",
        "Dumbbell Curls",
        "Hammer Curls",
        "Preacher Curls",
        "Concentration Curls",
        "Cable Curls",
        "Chin-Ups",
        "EZ-Bar Curls",
        "Incline Dumbbell Curls",
        "Spider Curls",
        "Tricep Dips",
        "Tricep Pushdowns",
        "Overhead Tricep Extension",
        "Skull Crushers",
        "Close-Grip Bench Press",
        "Tricep Kickbacks",
        "Dumbbell Overhead Extension",
        "Rope Pushdowns",
        "Reverse Grip Tricep Pushdowns",
        "Tricep Dips Machine"
    ]
    
    static let shoulderExercises : [String] = [
        "Shoulder Press",
        "Dumbbell Shoulder Press",
        "Arnold Press",
        "Lateral Raises",
        "Front Raises",
        "Rear Delt Flyes",
        "Upright Rows",
        "Shrugs",
        "Cable Lateral Raises",
        "Reverse Pec Deck Flyes"
    ]
    
    static let backExercises : [String] = [
        "Deadlifts",
        "Pull-Ups",
        "Lat Pulldowns",
        "Bent Over Rows",
        "T-Bar Rows",
        "Seated Rows",
        "One-Arm Dumbbell Rows",
        "Face Pulls",
        "Back Extensions",
        "Inverted Rows"
    ]
    
    static let legExercises : [String] = [
        "Squats",
        "Leg Press",
        "Lunges",
        "Leg Extensions",
        "Bulgarian Split Squats",
        "Hack Squats",
        "Sissy Squats",
        "Front Squats",
        "Step-Ups",
        "Goblet Squats",
        "Romanian Deadlifts",
        "Hamstring Curls",
        "Stiff-Legged Deadlifts",
        "Good Mornings",
        "Glute-Ham Raises",
        "Single-Leg Romanian Deadlifts",
        "Cable Pull-Throughs",
        "Kettlebell Swings",
        "Reverse Lunges",
        "Swiss Ball Hamstring Curls",
        "Hip Thrusts",
        "Glute Bridges",
        "Cable Kickbacks",
        "Sumo Deadlifts",
        "Single-Leg Glute Bridges",
        "Donkey Kicks",
        "Fire Hydrants",
        "Standing Calf Raises",
        "Seated Calf Raises",
        "Donkey Calf Raises",
        "Calf Press on Leg Press Machine",
        "Single-Leg Calf Raises",
        "Smith Machine Calf Raises"
    ]
}
