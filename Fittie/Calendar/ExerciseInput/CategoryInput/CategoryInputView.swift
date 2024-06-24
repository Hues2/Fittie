import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory?
    @State private var selectedExerciseCategoryId : String?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 24) {
                scrollView
                legend
            }
        }
        .onAppear {
            guard let exerciseCategory else {
                self.selectedExerciseCategoryId = ExerciseCategory.allCases.first?.rawValue
                return
            }
            self.selectedExerciseCategoryId = exerciseCategory.rawValue
        }
    }
    
    var scrollView : some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(ExerciseCategory.allCases) { exerciseCategory in
                    CategoryInputCardView(exerciseCategory: exerciseCategory,
                                          selectedExerciseCategory: $exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedExerciseCategoryId)
        .scrollIndicators(.hidden)
        .onChange(of: selectedExerciseCategoryId) { oldValue, newValue in
            print(newValue)
            guard let newValue else { return }
            self.exerciseCategory = ExerciseCategory(rawValue: newValue)
        }
    }
}

// MARK: Legend
private extension CategoryInputView {
    var legend : some View {
        HStack(spacing: 8) {
            ForEach(ExerciseCategory.allCases) { exerciseCategory in
                legendIcon(exerciseCategory.icon)
            }
        }
        .foregroundStyle(.secondary)
    }
    
    func legendIcon(_ icon : String) -> some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(height: 20)
    }
}

// MARK: Preview
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
