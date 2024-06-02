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
    @State private var previouslyLoggedExercisesIsExpanded : Bool = true
    @State private var showSetInputView : Bool = false
    
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
        .sheet(isPresented: $showSetInputView) {
            AddSetView { set in
                saveSet(set)
            }
            .withCustomSheetHeight()
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
                    categoryInput
                    exerciseNameInput
                    setsInput
                }
            }
            .scrollIndicators(.hidden)
            
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
                ForEach(ExerciseCategory.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { category in
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
                    withAnimation {
                        if exerciseName == loggedExercise.exerciseName.capitalized {
                            self.exerciseName = ""
                        } else {
                            self.exerciseName = loggedExercise.exerciseName.capitalized
                        }
                    }
                }
            }
        }
    }
}

// MARK: Sets Input
private extension ExerciseInputView {
    var setsInput : some View {
        VStack(spacing: 16) {
            setsInputHeader
            addedSetsView
        }
    }
    
    var setsInputHeader : some View {
        HStack {
            inputTitle("log_exercise_sets_title")
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundStyle(.accent)
        }
        .onTapGesture {
            self.showSetInputView = true
        }
    }
    
    var addedSetsView : some View {
        ForEach(Array(zip(0..<sets.count, sets)), id: \.0) { (index, set) in
            setCell(index + 1, set)
        }
    }
    
    func setCell(_ index : Int, _ set : WorkingSet) -> some View {
        HStack {
            Text("Set \(index)")
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("Weight: \(set.kg.toTwoDecimalPlacesString())")
                Text("Reps: \(set.reps)")
            }
        }
        .padding()
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    func saveSet(_ set : WorkingSet) {
        self.sets.append(set)
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
