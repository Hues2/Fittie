import Foundation
import SwiftData

@Model
class WorkoutModel {
    let id : String = UUID().uuidString
    var date : Date
    @Relationship(deleteRule: .cascade, inverse: \ExerciseModel.workout)
    var exercises = [ExerciseModel]()
    
    init(date: Date) {
        self.date = date
    }
}

struct Workout : Identifiable {
    let id : String = UUID().uuidString
    var date : Date
    var exercises = [Exercise]()
}
