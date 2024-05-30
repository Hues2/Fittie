import SwiftUI
import Combine

class ExercisesViewModel : ObservableObject {
    private let allExerciseCategories : [String: [String]] = [
        NSLocalizedString("exercise_category_title_chest", comment: "Chest") : Constants.chestExercises,
        NSLocalizedString("exercise_category_title_arms", comment: "Arms") : Constants.armExercises,
        NSLocalizedString("exercise_category_title_shoulders", comment: "Shoulders") : Constants.shoulderExercises,
        NSLocalizedString("exercise_category_title_back", comment: "Back") : Constants.backExercises,
        NSLocalizedString("exercise_category_title_legs", comment: "Legs") : Constants.legExercises
    ]
    
    @Published var filteredExerciseCategories : [String: [String]] = [
        NSLocalizedString("exercise_category_title_chest", comment: "Chest") : Constants.chestExercises,
        NSLocalizedString("exercise_category_title_arms", comment: "Arms") : Constants.armExercises,
        NSLocalizedString("exercise_category_title_shoulders", comment: "Shoulders") : Constants.shoulderExercises,
        NSLocalizedString("exercise_category_title_back", comment: "Back") : Constants.backExercises,
        NSLocalizedString("exercise_category_title_legs", comment: "Legs") : Constants.legExercises
    ]
    
    @Published var searchText : String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        subscribeToSearchText()
    }
    
    func subscribeToSearchText() {
        self.$searchText
            .dropFirst()
            .sink { [weak self] newSearchText in
                guard let self else { return }
                filterExerciseCategories(newSearchText.lowercased())
            }
            .store(in: &cancellables)
    }
    
    func filterExerciseCategories(_ newSearchText : String) {
        for (category, exercises) in allExerciseCategories {
            let filteredExercises = exercises.filter { $0.lowercased().starts(with: newSearchText) || $0.contains(newSearchText) }
            withAnimation {
                if filteredExercises.isEmpty {
                    filteredExerciseCategories.removeValue(forKey: category)
                } else {
                    filteredExerciseCategories[category] = filteredExercises
                }
            }
        }
    }
}
