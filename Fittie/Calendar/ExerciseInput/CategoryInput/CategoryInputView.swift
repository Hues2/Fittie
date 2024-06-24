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
            setExerciseCategory()
        }
    }
    
    var scrollView : some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(ExerciseCategory.allCases) { exerciseCategory in
                    CategoryInputCardView(exerciseCategory: exerciseCategory)
                    .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedExerciseCategoryId)
        .scrollIndicators(.hidden)
        .onChange(of: selectedExerciseCategoryId) { oldValue, newValue in
            guard let newValue else { return }
            self.exerciseCategory = ExerciseCategory(rawValue: newValue)
        }
    }
}

// MARK: Legend
private extension CategoryInputView {
    var legend : some View {
        HStack(spacing: 12) {
            ForEach(ExerciseCategory.allCases) { exerciseCategory in
                legendIcon(exerciseCategory)
            }
        }
        .padding()
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .compositingGroup()
        .shadow(color: .black.opacity(0.3), radius: 4)
    }
    
    func legendIcon(_ exerciseCategory : ExerciseCategory) -> some View {
        Image(exerciseCategory.icon)
            .resizable()
            .scaledToFit()
            .frame(height: 20)
            .foregroundStyle(exerciseCategory.id == selectedExerciseCategoryId ? .accent : .secondary)
    }
}

// MARK: Set the selected exercise category on appear
private extension CategoryInputView {
    func setExerciseCategory() {
        guard let exerciseCategory else {
            self.selectedExerciseCategoryId = ExerciseCategory.allCases.first?.id
            return
        }
        self.selectedExerciseCategoryId = exerciseCategory.id
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
