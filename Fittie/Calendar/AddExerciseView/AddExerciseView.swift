import SwiftUI

// MARK: This view is used to add a new exercise
struct AddExerciseView: View {
    @State var exerciseCategory : ExerciseCategory?
    @State var exerciseName : String = ""
    @State var sets : [WorkingSet] = []
    
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
        let newExercise = Exercise(exerciseCategoryRawValue: exerciseCategory.rawValue,
                                   exerciseName: exerciseName.lowercased().trimmingCharacters(in: [" "]),
                                   sets: sets)
        saveExercise(newExercise)
    }
}

#Preview {
    AddExerciseView { _ in
        
    }
}
