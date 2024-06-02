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
    
    let saveExercise : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 12)
        }
        .onAppear(perform: filterExercises)
        .onChange(of: exerciseCategory, { oldValue, newValue in
            filterExercises()
        })
        .onChange(of: loggedExercises, { oldValue, newValue in
            filterExercises()
        })
        .onChange(of: exerciseName) { oldValue, newValue in
            filterExercises()
        }        
    }
    
    private func filterExercises() {
        let filtered = loggedExercises
            .filter { $0.exerciseCategoryRawValue == exerciseCategory.rawValue }
            .filter { $0.exerciseName.lowercased().starts(with: exerciseName.lowercased()) || $0.exerciseName.contains(exerciseName.lowercased()) }
        
        let uniqueExerciseNames = Set(filtered.map { $0.exerciseName.lowercased() })
        withAnimation(.smooth) {
            filteredLoggedExercises = uniqueExerciseNames.compactMap { name in
                filtered.first { $0.exerciseName.lowercased() == name.lowercased() }
            }
        }
    }
}

private extension ExerciseInputView {
    var content : some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(spacing: 40) {
                    CategoryInputView(exerciseCategory: $exerciseCategory)
                    NameInputView(exerciseName: $exerciseName, filteredLoggedExercises: $filteredLoggedExercises)
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
