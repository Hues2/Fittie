import SwiftUI

// MARK: This view is used to add a new exercise
struct LogExerciseView: View {
    @State private var exerciseCategory : ExerciseCategory = .Arms
    @State private var exerciseName : String = ""
    let saveExerciseAction : (Exercise) -> Void
    
    var body: some View {
        ExerciseInputView(exerciseCategory: $exerciseCategory, exerciseName: $exerciseName) { saveExercise() }
    }
    
    func saveExercise() {
        let exercise = Exercise(exerciseCategoryRawValue: exerciseCategory.rawValue, exerciseName: exerciseName, sets: [])
        saveExerciseAction(exercise)
    }
}

#Preview {
    LogExerciseView { _ in
        
    }
}
