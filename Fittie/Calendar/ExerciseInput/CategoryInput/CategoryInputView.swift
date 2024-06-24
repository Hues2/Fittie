import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory?
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    // MARK: Arms
                    CategoryInputCardView(exerciseCategory: .Arms,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                    
                    // MARK: Back
                    CategoryInputCardView(exerciseCategory: .Back,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                    
                    // MARK: Chest
                    CategoryInputCardView(exerciseCategory: .Chest,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                    
                    // MARK: Shoulders
                    CategoryInputCardView(exerciseCategory: .Shoulders,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                    
                    // MARK: Legs
                    CategoryInputCardView(exerciseCategory: .Legs,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
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
