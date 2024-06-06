import Foundation

enum ExerciseCategory : String, Identifiable, CaseIterable {
    var id : String { UUID().uuidString }
    
    case Chest
    case Arms
    case Shoulders
    case Back
    case Legs
    
    var exerciseNames : [String] {
        switch self {
        case .Chest:
            Constants.chestExercises
        case .Arms:
            Constants.armExercises
        case .Shoulders:
            Constants.shoulderExercises
        case .Back:
            Constants.backExercises
        case .Legs:
            Constants.legExercises
        }}
    
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
