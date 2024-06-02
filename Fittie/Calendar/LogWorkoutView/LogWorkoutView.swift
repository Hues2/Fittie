import SwiftUI

struct LogWorkoutView: View {
    @State private var exercises : [Exercise] = []
    let calendarDate : CalendarDate
    let saveWorkout : (Workout) -> Void
    
    var body: some View {
        content
            .onAppear {
                print("Workout to be edited: \(calendarDate.workout)")
                // Set the exercises if a workout has already been logged for this date
                if let loggedExercises = calendarDate.workout?.exercises {
                    self.exercises = loggedExercises
                }
            }
    }
}

private extension LogWorkoutView {
    var content : some View {
        VStack(spacing: 0) {
            title
            loggedExercisesView
            saveWorkoutButton
        }
        .padding()
    }
    
    var title : some View {
        Text("log_workout_title")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
}

// MARK: List of exercises
private extension LogWorkoutView {
    var loggedExercisesView : some View {
        ScrollView {
            VStack {
                ForEach(exercises) { exercise in
                    exerciseCell(exercise)
                }
            }
        }
    }
    
    func exerciseCell(_ exercise : Exercise) -> some View {
        HStack {
            Text(exercise.exerciseName)
        }
    }
}

// MARK: Add exercise button
private extension LogWorkoutView {
    var saveWorkoutButton : some View {
        CustomButton(title: "log_workout_save_workout_btn_title") {
            let mockExercises : [Exercise] = [Exercise(exerciseName: "Dumbbell bench press",
                                                       sets: [.init(kg: 20, reps: 10),
                                                              .init(kg: 24, reps: 10),
                                                              .init(kg: 28, reps: 8)])]
            let mockWorkout = Workout(date: calendarDate.date, exercises: mockExercises)
            saveWorkout(mockWorkout)
        }
    }
}

#Preview {
    LogWorkoutView(calendarDate: .init(date: .now, workout: nil)) { _ in
        
    }
}
