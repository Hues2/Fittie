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
                VStack {
                    categoryInput
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
}

// MARK: Inputs
private extension ExerciseInputView {
    var categoryInput : some View {
        VStack {
            Text("Category")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.pink)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
