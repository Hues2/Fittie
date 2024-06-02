import SwiftUI
import SwiftData

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var exerciseCategory : ExerciseCategory
    @Binding var exerciseName : String
    @Binding var sets : [WorkingSet]
    @Query(sort: \Exercise.exerciseName, animation: .smooth) private var loggedExercises : [Exercise]
    
    @State private var filteredLoggedExercises : [Exercise] = []
    @State private var numberOfExercisesInCategory : Int = 0
    
    let saveExercise : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 16)
        }
        .onAppear {
            filterExercises(false)
            setExercisesInCategory(false)
        }
        .onChange(of: exerciseCategory) { oldValue, newValue in
            filterExercises()
            setExercisesInCategory()
        }
        .onChange(of: loggedExercises) { oldValue, newValue in
            filterExercises()
        }
        .onChange(of: exerciseName) { oldValue, newValue in
            filterExercises()
        }
    }
    
    private func filterExercises(_ animated : Bool = true) {
        let filtered = loggedExercises
            .filter { $0.exerciseCategoryRawValue == exerciseCategory.rawValue }
            .filter { $0.exerciseName.lowercased().starts(with: exerciseName.lowercased()) || $0.exerciseName.contains(exerciseName.lowercased()) }
        
        let uniqueExerciseNames = Set(filtered.map { $0.exerciseName.lowercased() })
        withAnimation(animated ? .smooth : .none) {
            filteredLoggedExercises = uniqueExerciseNames.compactMap { name in
                filtered.first { $0.exerciseName.lowercased() == name.lowercased() }
            }
        }
    }
    
    private func setExercisesInCategory(_ animated : Bool = true) {
        let exercises = loggedExercises
            .filter { $0.exerciseCategoryRawValue == exerciseCategory.rawValue }
        
        let uniqueExerciseNames = Set(exercises.map { $0.exerciseName.lowercased() })
        let uniqueExercises = uniqueExerciseNames.compactMap { name in
            exercises.first { $0.exerciseName.lowercased() == name.lowercased() }
        }
        withAnimation(animated ? .smooth : .none) {
            self.numberOfExercisesInCategory = uniqueExercises.count
        }
    }
}

private extension ExerciseInputView {
    var content : some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(spacing: 40) {
                    CategoryInputView(exerciseCategory: $exerciseCategory)
                    NameInputView(exerciseName: $exerciseName,
                                  filteredLoggedExercises: $filteredLoggedExercises,
                                  numberOfExercisesInCategory: numberOfExercisesInCategory)
                    SetsInputView(sets: $sets)
                }
            }
            .scrollIndicators(.hidden)
            
            saveExerciseButton
        }
        .padding()
    }
}

// MARK: Save exercise button
private extension ExerciseInputView {
    var saveExerciseButton : some View {
        CustomButton(title: "log_exercise_save_btn_title") {
            saveExercise()
            dismiss()
        }
    }
}

#Preview {
    ExerciseInputView(exerciseCategory: .constant(.Arms), exerciseName: .constant(""), sets: .constant([])) { }
}
