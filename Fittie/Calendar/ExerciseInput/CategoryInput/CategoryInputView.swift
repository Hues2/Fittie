import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 16) {
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
            .padding()
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
