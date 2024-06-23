import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory?
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                    CategoryInputCardView(exerciseCategory: .Arms,
                                          selectedExerciseCategory: $exerciseCategory)
                    CategoryInputCardView(exerciseCategory: .Back,
                                          selectedExerciseCategory: $exerciseCategory)
                    CategoryInputCardView(exerciseCategory: .Chest,
                                          selectedExerciseCategory: $exerciseCategory)
                    CategoryInputCardView(exerciseCategory: .Legs,
                                          selectedExerciseCategory: $exerciseCategory)
                    CategoryInputCardView(exerciseCategory: .Shoulders,
                                          selectedExerciseCategory: $exerciseCategory)
                }
                .padding(2)
        }
    }
}

fileprivate struct CategoryInputViewPreview : View {
    @State private var category : ExerciseCategory?
    
    var body: some View {
        ZStack {
            BackgroundView()
            CategoryInputView(exerciseCategory: $category)
        }
    }
}

#Preview {
    CategoryInputViewPreview()
}
