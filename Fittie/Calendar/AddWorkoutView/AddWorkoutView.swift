import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel : AddWorkoutViewModel
    @State private var showLogExercisesView : Bool = false
    @State private var showDeleteWorkoutAlert : Bool = false
    
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
        .alert("log_workout_delete_workout_alert_title",
               isPresented: $showDeleteWorkoutAlert) {
            Button("cancel", role: .cancel) { }
            Button("delete", role: .destructive) {
                // Add delete action here
                withAnimation {
                    guard let workoutModel = viewModel.calendarDate.workout else { return }
                    context.delete(workoutModel)
                    viewModel.workout = Workout(date: viewModel.calendarDate.date, exercises: [])
                    viewModel.savedWorkoutModel = nil
                }
            }
        } message: {
            Text("log_workout_delete_workout_alert_message")
        }
        
    }
}

private extension AddWorkoutView {
    var content : some View {
        VStack(spacing: 0) {
            header
                .padding(.top, 24)
                .padding(.bottom, 16)
            
            if !viewModel.workout.exercises.isEmpty {
                // There are saved or new exercises for the UI
                loggedExercisesView
                if !viewModel.newExercises.isEmpty {
                    // There are new exercises that can be saved
                    saveWorkoutButton
                }
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
        .padding(.top)
        .padding(.horizontal)
    }
}

// MARK: Header
private extension AddWorkoutView {
    var header : some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                mainTitle
                
                if !viewModel.isNewWorkout {
                    // Workout is already added
                    deleteButton
                    
                } else if !viewModel.workout.exercises.isEmpty {
                    // It's a new workout, but the first exercise has been added
                    addExerciseText
                }
            }
            
            Text(viewModel.calendarDate.date.formattedWithOrdinalSuffix())
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
        }
    }
    
    var mainTitle : some View {
        Text(viewModel.calendarDate.workout == nil ? "log_new_workout_title" : "log_workout_title")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color.secondaryAccent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var deleteButton : some View {
        IconButton(icon: "trash", color: Color.secondaryAccent) {
            // Show delete workout alert
            self.showDeleteWorkoutAlert = true
        }
    }
    
    var addExerciseText : some View {
        Text("log_workout_add_exercise_btn_title")
            .font(.title3)
            .fontWeight(.light)
            .foregroundStyle(.accent)
            .contentShape(Rectangle())
            .onTapGesture {
                self.showLogExercisesView = true
            }
    }
}

// MARK: List of exercises
private extension AddWorkoutView {
    var loggedExercisesView : some View {
        List {
            ForEach(viewModel.workout.exercises) { exercise in
                ExerciseCellView(category: exercise.exerciseCategoryRawValue,
                                 name: exercise.exerciseName,
                                 sets: exercise.sets,
                                 showExerciseName: true,
                                 showDeleteButton: viewModel.isNewWorkout,
                                 onDeleteExercise: {
                    self.viewModel.deleteExercise(exercise.id)
                })
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

// MARK: Append exercise to list
private extension AddWorkoutView {
    func addExercise(_ exercise : Exercise) {
        viewModel.addExercise(exercise)
    }
}

// MARK: Save workout button
private extension AddWorkoutView {
    var saveWorkoutButton : some View {
        CustomButton(title: "log_workout_save_workout_btn_title") {
            saveWorkout()
            dismiss()
        }
        .padding(.vertical)
    }
    
    func saveWorkout() {
        if let savedWorkoutModel = viewModel.savedWorkoutModel {
            // If there is already a saved workout, then just save the new exercises without creating a new workout
            saveListOfExercises(savedWorkoutModel)
        } else {
            // Create the new workout model that will be saved to swift data
            let workoutModel = WorkoutModel(date: viewModel.calendarDate.date)
            // Insert the new workout model into the context
            context.insert(workoutModel)
            
            saveListOfExercises(workoutModel)
        }
    }
    
    func saveListOfExercises(_ workoutModel : WorkoutModel) {
        for exercise in viewModel.newExercises {
            // Create a new exercise model for each exercise that was created by the user
            let exerciseModel = ExerciseModel(exerciseCategoryRawValue: exercise.exerciseCategoryRawValue,
                                              exerciseName: exercise.exerciseName)
            // Insert the new exercise model into the context
            context.insert(exerciseModel)
            // Set up the relationship between the exercise and the workout that it belongs to
            exerciseModel.workout = workoutModel
            
            for set in exercise.sets {
                // Create a working set model for each set that was inputted by the user
                let workingSetModel = WorkingSetModel(number: set.number, kg: set.kg, reps: set.reps)
                // Insert the working set into the context
                context.insert(workingSetModel)
                // Set up the relationship between the working set model and the exercise model
                workingSetModel.exercise = exerciseModel
            }
        }
    }
}

#Preview {
    AddWorkoutView(calendarDate: .init(date: .now, workout: nil))
}
