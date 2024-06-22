import Foundation

final class AddWorkoutViewModel : ObservableObject {
    // This is used for the UI
    // It is never used to create a new WorkoutModel
    @Published var workout : Workout
    var savedWorkoutModel : WorkoutModel?
            
    // Exercises used to create Exercise Models to then save into the context
    var newExercises = [Exercise]()
    
    let calendarDate : CalendarDate
    
    /* 
     This boolean is used to determine whether to display the delete button for each exercise
     User can only delete exercises if they are logging a new workout
     */
    @Published var isNewWorkout : Bool
    
    init(_ calendarDate : CalendarDate) {
        self.calendarDate = calendarDate
        guard let savedWorkout = calendarDate.workout else {
            // Is new workout sheet
            self.workout = Workout(date: calendarDate.date, exercises: [])
            self.savedWorkoutModel = nil
            self.isNewWorkout = true
            return
        }
        // User is viewing an already logged workout
        self.workout = savedWorkout.getWorkout()
        self.savedWorkoutModel = savedWorkout
        self.isNewWorkout = false
    }
}
