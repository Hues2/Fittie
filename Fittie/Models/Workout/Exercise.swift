import Foundation
import SwiftData

@Model
class Exercise {
    var exerciseCategoryRawValue : String
    var exerciseName : String
    @Relationship(deleteRule: .cascade, inverse: \WorkingSet.exercise)
    var sets = [WorkingSet]()
    var workout : Workout?
    
    init(exerciseCategoryRawValue: String, exerciseName: String) {
        self.exerciseCategoryRawValue = exerciseCategoryRawValue
        self.exerciseName = exerciseName
    }
}
