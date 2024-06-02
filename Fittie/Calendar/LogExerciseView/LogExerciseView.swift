import SwiftUI

// MARK: This view is used to add a new exercise
struct LogExerciseView: View {
    @State private var exerciseCategory : ExerciseCategory = .Arms
    @State private var exerciseName : String = ""
    
    var body: some View {
        ExerciseInputView(exerciseCategory: $exerciseCategory, exerciseName: $exerciseName)
    }
}

#Preview {
    LogExerciseView()
}
