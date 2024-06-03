import SwiftUI

// MARK: This view is used to add a new exercise
struct AddExerciseView: View {
    @State private var exerciseCategory : ExerciseCategory?
    @State private var exerciseName : String = ""
    @State private var sets : [WorkingSet] = []
    let saveExercise : (Exercise) -> Void
    
    var body: some View {
        ExerciseInputView(exerciseCategory: $exerciseCategory,
                          exerciseName: $exerciseName,
                          sets: $sets) {
            saveExerciseAction()
        }
    }
    
    func saveExerciseAction() {
        guard let exerciseCategory else { return }
        let exercise = Exercise(exerciseCategoryRawValue: exerciseCategory.rawValue,
                                exerciseName: exerciseName.lowercased(),
                                sets: sets)
        saveExercise(exercise)
    }
}

#Preview {
    AddExerciseView { _ in
        
    }
}
