import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory?
    @State private var visibleExerciseCategory : Int?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                scrollView
                
//                legend
            }
        }
    }
    
    var scrollView : some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
//                ForEach(ExerciseCategory.allCases, id:\.rawValue) { exerciseCategory in
//                    CategoryInputCardView(exerciseCategory: exerciseCategory,
//                                          selectedExerciseCategory: $exerciseCategory)
//                }
                // MARK: Arms
                CategoryInputCardView(exerciseCategory: .Arms,
                                      selectedExerciseCategory: $exerciseCategory)
                .containerRelativeFrame(.horizontal)
                .id(0)
                
                // MARK: Back
                CategoryInputCardView(exerciseCategory: .Back,
                                      selectedExerciseCategory: $exerciseCategory)
                .containerRelativeFrame(.horizontal)
                .id(1)
                
                // MARK: Chest
                CategoryInputCardView(exerciseCategory: .Chest,
                                      selectedExerciseCategory: $exerciseCategory)
                .containerRelativeFrame(.horizontal)
                .id(2)
                
                // MARK: Shoulders
                CategoryInputCardView(exerciseCategory: .Shoulders,
                                      selectedExerciseCategory: $exerciseCategory)
                .containerRelativeFrame(.horizontal)
                .id(3)
                
                // MARK: Legs
                CategoryInputCardView(exerciseCategory: .Legs,
                                      selectedExerciseCategory: $exerciseCategory)
                .containerRelativeFrame(.horizontal)
                .id(4)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $visibleExerciseCategory)
        .scrollIndicators(.hidden)
        .onChange(of: visibleExerciseCategory) { oldValue, newValue in
            print(newValue)
        }
    }
    
    var legend : some View {
        HStack(spacing: 8) {
            Image(ExerciseCategory.Arms.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            Image(ExerciseCategory.Back.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            Image(ExerciseCategory.Chest.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            Image(ExerciseCategory.Shoulders.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            Image(ExerciseCategory.Legs.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
        }
        .foregroundStyle(.secondary)
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
