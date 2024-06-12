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
