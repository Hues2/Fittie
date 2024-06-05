import Foundation
import SwiftData

@Model
class ExerciseModel {
    var exerciseCategoryRawValue : String
    var exerciseName : String
    @Relationship(deleteRule: .cascade, inverse: \WorkingSetModel.exercise)
    var sets = [WorkingSetModel]()
    var workout : WorkoutModel?
    
    init(exerciseCategoryRawValue: String, exerciseName: String) {
        self.exerciseCategoryRawValue = exerciseCategoryRawValue
        self.exerciseName = exerciseName
    }
}

struct Exercise : Identifiable {
    let id : String = UUID().uuidString
    var exerciseCategoryRawValue : String
    var exerciseName : String
    var sets = [WorkingSet]()    
}
