import SwiftUI

enum ExercisePage : Int, CaseIterable {
    case categorySelection = 0
    case exerciseNameInput = 1
    case setInput = 2
    
    var title : LocalizedStringKey {
        switch self {
        case .categorySelection:
            "log_exercise_category_title"
        case .exerciseNameInput:
            "log_exercise_exercise_title"
        case .setInput:
            "log_exercise_sets_title"
        }
    }
    
    var buttonTitle : LocalizedStringKey {
        switch self {
        case .categorySelection:
            return "onboarding_next_button_title"
        case .exerciseNameInput:
            return "onboarding_next_button_title"
        case .setInput:
            return "onboarding_set_permissions_button_title"
        }
    }
}
