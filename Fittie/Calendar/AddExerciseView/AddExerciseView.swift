import SwiftUI

// MARK: This view is used to add a new exercise
struct AddExerciseView: View {
    @Environment(\.modelContext) private var context
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
        // Insert new exercise into the context
        let newExercise = Exercise(exerciseCategoryRawValue: exerciseCategory.rawValue,
                                   exerciseName: exerciseName.lowercased())
        context.insert(newExercise)
        
        for set in sets {
            // insert each set into the context (table of working sets)
            context.insert(set)
            // Set up the relationship between the new exercise and this WorkingSet
            set.exercise = newExercise
        }
        
        saveExercise(newExercise)
    }
}

#Preview {
    AddExerciseView { _ in
        
    }
}
