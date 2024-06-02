import SwiftUI

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    @Binding var exerciseName : String
    let saveExerciseAction : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 12)
        }
    }
}

private extension ExerciseInputView {
    var content : some View {
        VStack {
            title
            
            ScrollView {
                VStack(spacing: 32) {
                    categoryInput
                    exerciseNameInput
                }
            }
        }
        .padding()
    }
    
    var title : some View {
        Text("log_exercise_title")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func inputTitle(_ title : LocalizedStringKey) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: Category Input
private extension ExerciseInputView {
    var categoryInput : some View {
        VStack(spacing: 16) {
            inputTitle("log_exercise_category_title")
            
            Picker("", selection: $exerciseCategory) {
                ForEach(ExerciseCategory.allCases) { category in
                    Text(category.rawValue)
                        .tag(category)
                }
            }
            .pickerStyle(.segmented)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: Exercise Name Input
private extension ExerciseInputView {
    var exerciseNameInput : some View {
        inputTitle("log_exercise_exercise_name_title")
    }
}

// MARK: Save exercise button
private extension ExerciseInputView {
    var saveExerciseButton : some View {
        CustomButton(title: "log_exercise_save_btn_title") {
            saveExerciseAction()
        }
    }
}

#Preview {
    ExerciseInputView(exerciseCategory: .constant(.Arms), exerciseName: .constant("Bench Press")) { }
}
