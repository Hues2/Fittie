import Foundation

class AddWorkoutViewModel : ObservableObject {
    // This is used for the UI
    // It is never used to create a new WorkoutModel
    @Published var workout : Workout
    let savedWorkoutModel : WorkoutModel?
            
    // Exercises used to create Exercise Models to then save into the context
    var newExercises = [Exercise]()
    
    let calendarDate : CalendarDate
    
    init(_ calendarDate : CalendarDate) {
        self.calendarDate = calendarDate
        guard let savedWorkout = calendarDate.workout else {
            self.workout = Workout(date: calendarDate.date, exercises: [])
            self.savedWorkoutModel = nil
            return
        }
        self.workout = savedWorkout.getWorkout()
        self.savedWorkoutModel = savedWorkout
    }
}

// MARK: Delete set functionality
extension AddWorkoutViewModel {
    func deleteSet(_ exerciseId : String, _ setIndex : Int) {
        // Delete the set from the exercise used by the UI
        if let exerciseIndex = self.workout.exercises.firstIndex(where: { $0.id == exerciseId }) {
            self.workout.exercises[exerciseIndex].sets.remove(at: setIndex)
            
            // Reset the sets number
            self.workout.exercises[exerciseIndex].sets = Array(self.workout.exercises[exerciseIndex].sets).enumerated().map { (index, set) in
                WorkingSet(number: index + 1, kg: set.kg, reps: set.reps)
            }
            
            if self.workout.exercises[exerciseIndex].sets.isEmpty {
                self.workout.exercises.remove(at: exerciseIndex)
            }
        }
        
        // Remove the set from the new exercise, so that the set doesn't get saved to the container
        if let exerciseIndex = self.newExercises.firstIndex(where: { $0.id == exerciseId }) {
            self.newExercises[exerciseIndex].sets.remove(at: setIndex)
            
            // Reset the sets number
            self.newExercises[exerciseIndex].sets = Array(self.newExercises[exerciseIndex].sets).enumerated().map { (index, set) in
                WorkingSet(number: index + 1, kg: set.kg, reps: set.reps)
            }
            
            if newExercises[exerciseIndex].sets.isEmpty {
                newExercises.remove(at: exerciseIndex)
            }
        }
    }
}
