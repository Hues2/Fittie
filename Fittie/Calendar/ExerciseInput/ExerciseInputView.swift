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
    @State private var exercisePageId : Int?
    
    @State private var filteredLoggedExercises : [Exercise] = []
    @State private var numberOfExercisesInCategory : Int = 0
    
    let saveExercise : () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
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
    }
}

// MARK: Content
private extension ExerciseInputView {
    var content : some View {
        VStack(spacing: Constants.paddingAboveSaveButton) {
            pageTitle
            scrollView
            nextPageButton
        }
    }
}

// MARK: Page Title
private extension ExerciseInputView {
    var pageTitle : some View {
        ExerciseInputTabViewTitle(title: exercisePage.title,
                   showBackButton: (exercisePage.rawValue > ExercisePage.categorySelection.rawValue)) { previousPage() }
            .animation(.none, value: exercisePage)
            .padding(.top, 24)
            .padding()
    }
}

// MARK: Paging ScrollView
private extension ExerciseInputView {
    var scrollView : some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                categoryInputPage
                
                nameInputView
                
                setsInputView
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .contentMargins(.zero)
        .scrollDisabled(true)
        .scrollPosition(id: $exercisePageId)
    }
    
    var categoryInputPage : some View {
        CategoryInputView(exerciseCategory: $exerciseCategory)
            .id(ExercisePage.categorySelection.id)
            .containerRelativeFrame(.horizontal)
    }
    
    var nameInputView : some View {
        NameInputView(exerciseName: $exerciseName,
                      filteredLoggedExercises: $filteredLoggedExercises,
                      numberOfExercisesInCategory: numberOfExercisesInCategory)
        .id(ExercisePage.exerciseNameInput.id)
        .padding()
        .containerRelativeFrame(.horizontal)
        // Have to add this here, as the textfield inside this view causes the sheet to lose its corner radius (for some reason)
        .presentationCornerRadius(Constants.sheetCornerRadius)
    }
    
    var setsInputView : some View {
        SetsInputView(sets: $sets)
            .id(ExercisePage.setInput.id)
            .padding()
            .containerRelativeFrame(.horizontal)
    }
}

// MARK: Button
private extension ExerciseInputView {
    var nextPageButton : some View {
        CustomButton(title: exercisePage.buttonTitle) {
            buttonAction()
        }
        .padding(.bottom, 4)
        .animation(.none, value: exercisePage)
        .disabled(buttonIsDisabled())
        .padding()
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
                self.exercisePageId = nextPage.id
            }
        }
    }
    
    private func previousPage() {
        if let previousPage = ExercisePage(rawValue: exercisePage.rawValue - 1) {
            withAnimation(.smooth) {
                exercisePage = previousPage
                self.exercisePageId = previousPage.id
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



// MARK: Preview
#Preview {
    Color.background
        .sheet(isPresented: .constant(true), content: {
            ExerciseInputView(exerciseCategory: .constant(.Arms),
                              exerciseName: .constant(""),
                              sets: .constant([])) { }
//                .withCustomSheetHeight()
        })
}
