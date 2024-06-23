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
    // This is the list of previously logged exercises
    // This allows the user to quickly select an already saved exercise
    @Query(sort: \ExerciseModel.exerciseName, animation: .smooth) private var loggedExercises : [ExerciseModel]
        
    @State private var exercisePage : ExercisePage = .categorySelection
    @State private var filteredLoggedExercises : [Exercise] = []
    @State private var numberOfExercisesInCategory : Int = 0
    
    let saveExercise : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding()
        }
        .onAppear {
            filterExercises(false)
            setExercisesInCategory(false)
        }
        .onChange(of: exerciseCategory) { oldValue, newValue in
            resetValues()
            filterExercises()
            setExercisesInCategory()
        }
        .onChange(of: loggedExercises) { oldValue, newValue in
            filterExercises()
        }
        .onChange(of: exerciseName) { oldValue, newValue in
            filterExercises()
        }
        .onDisappear {
            Utils.disableScroll(true)
        }
    }
}

// MARK: Content
private extension ExerciseInputView {
    var content : some View {
        VStack(spacing: Constants.paddingAboveSaveButton) {
            tabViewTitle
            tabView
            nextPageButton
        }
    }
    
    var tabViewTitle : some View {
        ExerciseInputTabViewTitle(title: exercisePage.title,
                   showBackButton: (exercisePage.rawValue > ExercisePage.categorySelection.rawValue)) { previousPage() }
            .animation(.none, value: exercisePage)
            .padding(.top, 24)
    }
    
    var tabView : some View {
        TabView(selection: $exercisePage) {
            CategoryInputView(exerciseCategory: $exerciseCategory)
                .tag(ExercisePage.categorySelection)
            
            NameInputView(exerciseName: $exerciseName,
                          filteredLoggedExercises: $filteredLoggedExercises,
                          numberOfExercisesInCategory: numberOfExercisesInCategory)
            .tag(ExercisePage.exerciseNameInput)
            // Have to add this here, as the textfield inside this view causes the sheet to lose its corner radius (for some reason)
            .presentationCornerRadius(Constants.sheetCornerRadius)
            
            SetsInputView(sets: $sets)
                .tag(ExercisePage.setInput)
        }
        .presentationCornerRadius(Constants.sheetCornerRadius)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            // Block the swipe gesture for the tab view
            Utils.disableScroll(false)
        }
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
            saveExercise()
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
            // TODO: This shouldn't use the filter text
            return exerciseName.isEmpty
        case .setInput:
            return sets.isEmpty
        }
    }
}

// MARK: Filter functions
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
            .map({ Exercise(exerciseCategoryRawValue: $0.exerciseCategoryRawValue, exerciseName: $0.exerciseName, sets: $0.sets.map({ WorkingSet(number: $0.number, kg: $0.kg, reps: $0.reps) })) })
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

// MARK: Reset values
private extension ExerciseInputView {
    func resetValues() {
        self.exerciseName = ""
        self.sets = []
    }
}

#Preview {
    Color.background
        .sheet(isPresented: .constant(true), content: {
            ExerciseInputView(exerciseCategory: .constant(.Arms),
                              exerciseName: .constant(""),
                              sets: .constant([])) { }
//                .withCustomSheetHeight()
        })
}
