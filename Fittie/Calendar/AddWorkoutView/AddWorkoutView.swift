import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var exercises : [Exercise] = []
    @State private var showLogExercisesView : Bool = false
    let calendarDate : CalendarDate
    let saveWorkout : (Workout) -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
        }
        .onAppear {
            // Set the exercises if a workout has already been logged for this date
            if let loggedExercises = calendarDate.workout?.exercises {
                self.exercises = loggedExercises
            }
        }
        .sheet(isPresented: $showLogExercisesView) {
            // Add a new exercise
            AddExerciseView { exercise in
                addExercise(exercise)
            }
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Constants.sheetCornerRadius)
        }
    }
}

private extension AddWorkoutView {
    var content : some View {
        VStack(spacing: Constants.paddingAboveSaveButton) {
            title
                .padding(.top, 24)
            
            if !exercises.isEmpty {
                loggedExercisesView
                saveWorkoutButton
            } else {
                AddItemTextView(title: "log_workout_add_exercise_btn_title", font: .title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.showLogExercisesView = true
                    }
            }
        }
        .frame(maxHeight: .infinity)
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

// MARK: List of exercises
private extension AddWorkoutView {
    var loggedExercisesView : some View {
        VStack {
            ScrollView {
                ForEach(exercises) { exercise in
                    ExerciseCellView(category: exercise.exerciseCategoryRawValue,
                                     name: exercise.exerciseName,
                                     sets: exercise.sets)
                }
            }
            .frame(maxWidth: .infinity)
            
            AddItemTextView(title: "log_workout_add_exercise_btn_title", font: .title3)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.showLogExercisesView = true
                }
        }
    }
}

// MARK: Save exercise
private extension AddWorkoutView {
    func addExercise(_ exercise : Exercise) {
        self.exercises.append(exercise)
    }
}

// MARK: Save workout button
private extension AddWorkoutView {
    var saveWorkoutButton : some View {
        CustomButton(title: "log_workout_save_workout_btn_title") {
            let workout = Workout(date: calendarDate.date, exercises: exercises)
            saveWorkout(workout)
            dismiss()
        }
    }
}

#Preview {
    AddWorkoutView(calendarDate: .init(date: .now, workout: nil)) { _ in
        
    }
}
