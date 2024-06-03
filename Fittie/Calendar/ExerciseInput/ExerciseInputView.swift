import SwiftUI
import SwiftData

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    // Dismiss exercise input on save
    @Environment(\.dismiss) private var dismiss
    
    // Exercise values
    @Binding var exerciseCategory : ExerciseCategory?
    @Binding var exerciseName : String
    @Binding var sets : [WorkingSet]
    @Query(sort: \Exercise.exerciseName, animation: .smooth) private var loggedExercises : [Exercise]
    
    // Tabview page
    @State private var exercisePage : ExercisePage = .categorySelection
    
    @State private var filteredLoggedExercises : [Exercise] = []
    @State private var numberOfExercisesInCategory : Int = 0
    
    let saveExercise : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding()
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
}

// MARK: Content
private extension ExerciseInputView {
    var content : some View {
        VStack(spacing: 36) {
            InputTitle(title: exercisePage.title,
                       showBackButton: (exercisePage.rawValue > ExercisePage.categorySelection.rawValue)) { previousPage() }
                .animation(.none, value: exercisePage)
            
            tabView
            
            nextPageButton
        }
        .onAppear {
            // Block the swipe gesture for the tab view
            UIScrollView.appearance().isScrollEnabled = false
        }
    }
    
    var tabView : some View {
        TabView(selection: $exercisePage) {
            CategoryInputView(exerciseCategory: $exerciseCategory)
                .tag(ExercisePage.categorySelection)
            
            NameInputView(exerciseName: $exerciseName,
                          filteredLoggedExercises: $filteredLoggedExercises,
                          numberOfExercisesInCategory: numberOfExercisesInCategory)
            .tag(ExercisePage.exerciseNameInput)
            
            SetsInputView(sets: $sets)
                .tag(ExercisePage.setInput)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

// MARK: Tabview button
private extension ExerciseInputView {
    var nextPageButton : some View {
        CustomButton(title: exercisePage.buttonTitle) {
            buttonAction()
        }
        .padding(.bottom, 4)
        .animation(.none, value: exercisePage)
        .disabled(buttonIsDisabled())
    }
    
    private func buttonAction() {
        switch exercisePage {
        case .categorySelection:
            nextPage()
        case .exerciseNameInput:
            nextPage()
        case .setInput:
            dismiss()
        }
    }
    
    private func nextPage() {
        if let nextPage = ExercisePage(rawValue: exercisePage.rawValue + 1) {
            withAnimation(.smooth) {
                exercisePage = nextPage
            }
        }
    }
    
    private func previousPage() {
        if let previousPage = ExercisePage(rawValue: exercisePage.rawValue - 1) {
            withAnimation(.smooth) {
                exercisePage = previousPage
            }
        }
    }
    
    private func buttonIsDisabled() -> Bool {
        switch exercisePage {
        case .categorySelection:
            return exerciseCategory == nil
        case .exerciseNameInput:
            return exerciseName.isEmpty
        case .setInput:
            return sets.isEmpty
        }
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

// MARK: Filter funcitons
private extension ExerciseInputView {
    func filterExercises(_ animated : Bool = true) {
        let filtered = loggedExercises
            .filter { $0.exerciseCategoryRawValue == exerciseCategory?.rawValue }
            .filter { $0.exerciseName.lowercased().starts(with: exerciseName.lowercased()) || $0.exerciseName.contains(exerciseName.lowercased()) }
        
        let uniqueExerciseNames = Set(filtered.map { $0.exerciseName.lowercased() })
        withAnimation(animated ? .smooth : .none) {
            filteredLoggedExercises = uniqueExerciseNames.compactMap { name in
                filtered.first { $0.exerciseName.lowercased() == name.lowercased() }
            }
        }
    }
    
    func setExercisesInCategory(_ animated : Bool = true) {
        let exercises = loggedExercises
            .filter { $0.exerciseCategoryRawValue == exerciseCategory?.rawValue }
        
        let uniqueExerciseNames = Set(exercises.map { $0.exerciseName.lowercased() })
        let uniqueExercises = uniqueExerciseNames.compactMap { name in
            exercises.first { $0.exerciseName.lowercased() == name.lowercased() }
        }
        withAnimation(animated ? .smooth : .none) {
            self.numberOfExercisesInCategory = uniqueExercises.count
        }
    }
}

#Preview {
    ExerciseInputView(exerciseCategory: .constant(.Arms), exerciseName: .constant(""), sets: .constant([])) { }
}
