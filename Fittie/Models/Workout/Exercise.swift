import Foundation
import SwiftData

@Model
class Exercise {
    var exerciseName : String
    var sets : [WorkingSet]
    
    init(exerciseName: String, sets: [WorkingSet]) {
        self.exerciseName = exerciseName
        self.sets = sets
    }
}
