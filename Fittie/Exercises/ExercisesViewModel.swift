import SwiftUI
import Combine

class ExercisesViewModel : ObservableObject {
    private let allExerciseCategories : [String: [String]] = [
        "Chest" : Constants.chestExercises,
        "Arms" : Constants.armExercises,
        "Shoulders" : Constants.shoulderExercises,
        "Back" : Constants.backExercises,
        "Legs" : Constants.legExercises
    ]
    
    @Published var filteredExerciseCategories : [String: [String]] = [
        "Chest" : Constants.chestExercises,
        "Arms" : Constants.armExercises,
        "Shoulders" : Constants.shoulderExercises,
        "Back" : Constants.backExercises,
        "Legs" : Constants.legExercises
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
                filterExerciseCategories(newSearchText)
            }
            .store(in: &cancellables)
    }
    
    func filterExerciseCategories(_ newSearchText : String) {
        for (category, exercises) in allExerciseCategories {
            let filteredExercises = exercises.filter { $0.starts(with: newSearchText) || $0.contains(newSearchText) }
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
