import SwiftUI

struct LogWorkoutView: View {
    @State private var exercises : [Exercise] = []
    @State private var showLogExercisesView : Bool = false
    let calendarDate : CalendarDate
    let saveWorkout : (Workout) -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 12)
                .onAppear {
                    print("Workout to be edited: \(calendarDate.workout)")
                    // Set the exercises if a workout has already been logged for this date
                    if let loggedExercises = calendarDate.workout?.exercises {
                        self.exercises = loggedExercises
                    }
                }
        }
        .sheet(isPresented: $showLogExercisesView) {
            // Add a new exercise
            LogExerciseView { exercise in
                saveExercise(exercise)
            }
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Constants.sheetCornerRadius)
        }
    }
}

private extension LogWorkoutView {
    var content : some View {
        VStack(spacing: 0) {
            title
            
            if !exercises.isEmpty {
                loggedExercisesView
                saveWorkoutButton
            } else {
                addExerciseButton
                    .frame(maxHeight: .infinity)
            }
        }
        .padding()
    }
    
    var title : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("log_workout_title")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.pink)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(calendarDate.date.formattedWithOrdinalSuffix())
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: Add exercise button
private extension LogWorkoutView {
    var addExerciseButton : some View {
        Button {
            self.showLogExercisesView = true
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("log_workout_add_exercise_btn_title")
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.accent)
            .frame(maxWidth: .infinity)
            .padding()
            .contentShape(Rectangle())
        }
    }
}

// MARK: List of exercises
private extension LogWorkoutView {
    var loggedExercisesView : some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(exercises) { exercise in
                        exerciseCell(exercise)
                    }
                }
            }
            addExerciseButton
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
            // TODO: Save workout
        }
    }
}

// MARK: Save exercise
private extension LogWorkoutView {
    func saveExercise(_ exercise : Exercise) {
        // TODO: Add exercise to the list of exercises
    }
}

#Preview {
    LogWorkoutView(calendarDate: .init(date: .now, workout: nil)) { _ in
        
    }
}
