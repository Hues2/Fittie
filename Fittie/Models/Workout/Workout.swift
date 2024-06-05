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
    
    func getWorkout() -> Workout {
        return Workout(date: self.date, exercises: self.exercises.map({ $0.getExercise() }))
    }
}

struct Workout : Identifiable {
    let id : String = UUID().uuidString
    var date : Date
    var exercises = [Exercise]()
}
