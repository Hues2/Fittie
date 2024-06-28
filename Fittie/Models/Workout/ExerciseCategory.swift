import Foundation

enum ExerciseCategory : String, Identifiable, CaseIterable, Hashable {
    case Arms
    case Back
    case Chest
    case Shoulders
    case Legs
    
    var id : String { self.rawValue }
    
    var icon : String {
        switch self {
        case .Chest:
            "chest_category"
        case .Arms:
            "arms_category"
        case .Shoulders:
            "shoulders_category"
        case .Back:
            "back_category"
        case .Legs:
            "legs_category"
        }
    }
}
