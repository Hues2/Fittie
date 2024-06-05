import Foundation

class AddWorkoutViewModel : ObservableObject {
    @Published var workout : Workout
    
    let calendarDate : CalendarDate
    
    init(_ calendarDate : CalendarDate) {
        self.calendarDate = calendarDate
        guard let savedWorkout = calendarDate.workout else {
            self.workout = Workout(date: calendarDate.date, exercises: [])
            return
        }
        self.workout = savedWorkout
    }
}
