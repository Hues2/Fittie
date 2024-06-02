import SwiftUI
import SwiftData

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    @Binding var exerciseName : String
    @Query(sort: \Exercise.exerciseName, animation: .smooth) private var loggedExercises : [Exercise]
    @State private var filteredLoggedExercises : [Exercise] = []
    @State private var previouslyLoggedExercisesIsExpanded : Bool = true
    let saveExerciseAction : () -> Void
    
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
    }
    
    private func filterExercises() {
        let filtered = loggedExercises.filter { $0.exerciseCategoryRawValue == exerciseCategory.rawValue }
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
            
            exerciseNameTextField
            
            previouslyLoggedExerciseNamesView
        }
    }
    
    var exerciseNameTextField : some View {
        TextField("", text: $exerciseName, prompt: Text("log_exercise_name_textfield_prompt"))
    }
    
    @ViewBuilder var previouslyLoggedExerciseNamesView : some View {
        if !filteredLoggedExercises.isEmpty {
            VStack(spacing: 0) {
                previouslyLoggedExerciseNamesViewTitle
                
                if previouslyLoggedExercisesIsExpanded {
                    previouslyLoggedExerciseNamesListView
                }
            }
            .padding(.top, 8)
        }
    }
    
    var previouslyLoggedExerciseNamesViewTitle : some View {
        HStack {
            Text("log_exercise_saved_exercises_title")
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
    }
    
    var previouslyLoggedExerciseNamesListView : some View {
        VStack {
            ForEach(filteredLoggedExercises) { loggedExercise in
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
