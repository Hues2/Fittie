import SwiftUI

enum ExercisePage : Int, CaseIterable {
    case categorySelection = 0
    case exerciseNameInput = 1
    case setInput = 2
    
    var title : LocalizedStringKey {
        switch self {
        case .categorySelection:
            "exercise_page_category_title"
        case .exerciseNameInput:
            "exercise_page_exercise_title"
        case .setInput:
            "exercise_page_sets_title"
        }
    }
    
    var buttonTitle : LocalizedStringKey {
        switch self {
        case .categorySelection:
            return "exercise_page_next_button_title"
        case .exerciseNameInput:
            return "exercise_page_next_button_title"
        case .setInput:
            return "exercise_page_save_button_title"
        }
    }
}
