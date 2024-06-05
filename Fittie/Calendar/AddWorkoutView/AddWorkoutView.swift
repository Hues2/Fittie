import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel : AddWorkoutViewModel
    @State private var showLogExercisesView : Bool = false
    
    init(calendarDate: CalendarDate) {
        // Pass in the calendar date to the viewmodel.
        // Calendar date contains the date and the optional workout that could have already been logged for this day
        self._viewModel = StateObject(wrappedValue: AddWorkoutViewModel(calendarDate))
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
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
            
            if !viewModel.workout.exercises.isEmpty {
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
            
            Text(viewModel.calendarDate.date.formattedWithOrdinalSuffix())
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
                VStack(spacing: 16) {
                    ForEach(viewModel.workout.exercises) { exercise in
                        ExerciseCellView(category: exercise.exerciseCategoryRawValue,
                                         name: exercise.exerciseName,
                                         sets: exercise.sets)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
            
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
        self.viewModel.workout.exercises.append(exercise)
    }
}

// MARK: Save workout button
private extension AddWorkoutView {
    var saveWorkoutButton : some View {
        CustomButton(title: "log_workout_save_workout_btn_title") {
            // Create the new workout model that will be saved to swift data
            let workoutModel = WorkoutModel(date: viewModel.calendarDate.date)
            // Insert the new workout model into the context
            context.insert(workoutModel)
            
            for exercise in viewModel.workout.exercises {
                // Create a new exercise model for each exercise that was created by the user
                let exerciseModel = ExerciseModel(exerciseCategoryRawValue: exercise.exerciseCategoryRawValue,
                                                  exerciseName: exercise.exerciseName)
                // Insert the new exercise model into the context
                context.insert(exerciseModel)
                // Set up the relationship between the exercise and the workout that it belongs to
                exerciseModel.workout = workoutModel
                
                for set in exercise.sets {
                    // Create a working set model for each set that was inputted by the user
                    let workingSetModel = WorkingSetModel(kg: set.kg, reps: set.reps)
                    // Insert the working set into the context
                    context.insert(workingSetModel)
                    // Set up the relationship between the working set model and the exercise model
                    workingSetModel.exercise = exerciseModel
                }
            }
            
            dismiss()
        }
    }
}

#Preview {
    AddWorkoutView(calendarDate: .init(date: .now, workout: nil))
}
