import Foundation
import SwiftData

@Model
class Workout {
    let id : String = UUID().uuidString
    var date : Date
    var exercises : [Exercise]
    
    init(date: Date, exercises: [Exercise]) {
        self.date = date
        self.exercises = exercises
    }
}

@Model
class Exercise {
    var exerciseName : String
    var sets : [WorkingSet]
    
    init(exerciseName: String, sets: [WorkingSet]) {
        self.exerciseName = exerciseName
        self.sets = sets
    }
}

@Model
class WorkingSet {
    var kg : Double
    var reps : Int
    
    init(kg: Double, reps: Int) {
        self.kg = kg
        self.reps = reps
    }
}

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

