import SwiftUI
import SwiftData

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    @Binding var exerciseName : String
    @Query(sort: \Exercise.exerciseName, animation: .smooth) private var loggedExercises : [Exercise]
    @State private var previouslyLoggedExercisesIsExpanded : Bool = false
    let saveExerciseAction : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 12)
        }
        .onAppear {
            print("LOGGED EXERCISES -> \(loggedExercises.first?.exerciseName)")
        }
    }
}

private extension ExerciseInputView {
    var content : some View {
        VStack {
            ScrollView {
                VStack(spacing: 40) {
                    categoryInput
                    exerciseNameInput
                }
            }
            saveExerciseButton
        }
        .padding()
    }
    
    func inputTitle(_ title : LocalizedStringKey) -> some View {
        Text(title)
            .font(.title)
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
        VStack(spacing: 16) {
            inputTitle("log_exercise_exercise_title")
            
            TextField("", text: $exerciseName, prompt: Text("Add exercise"))
            
            if !loggedExercises.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Text("Saved exercises")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.up")
                            .rotationEffect(previouslyLoggedExercisesIsExpanded ? Angle(degrees: 180) : .zero)
                    }
                    .foregroundStyle(.pink)
                    .padding(.vertical)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.smooth) {
                            self.previouslyLoggedExercisesIsExpanded.toggle()
                        }
                    }
                    
                    if previouslyLoggedExercisesIsExpanded {
                        VStack {
                            ForEach(loggedExercises) { loggedExercise in
                                HStack {
                                    Text(loggedExercise.exerciseName.capitalized)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if exerciseName.lowercased() == loggedExercise.exerciseName.lowercased() {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.accent)
                                    }
                                }
                                .padding()
                                .background(Constants.backgroundMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                                .overlay {
                                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                        .stroke((exerciseName.lowercased() == loggedExercise.exerciseName.lowercased()) ? .accent : .clear)
                                }
                                .onTapGesture {
                                    self.exerciseName = loggedExercise.exerciseName.capitalized
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
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
    ExerciseInputView(exerciseCategory: .constant(.Arms), exerciseName: .constant("")) { }
}
