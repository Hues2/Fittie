import Foundation
import SwiftData

@Model
class Exercise {
    var exerciseCategoryRawValue : String
    var exerciseName : String
    var sets : [WorkingSet]
    
    init(exerciseCategoryRawValue: String, exerciseName: String, sets: [WorkingSet]) {
        self.exerciseCategoryRawValue = exerciseCategoryRawValue
        self.exerciseName = exerciseName
        self.sets = sets
    }
}
