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
}
