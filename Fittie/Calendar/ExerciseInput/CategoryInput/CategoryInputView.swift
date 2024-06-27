import SwiftUI

struct CategoryInputView: View {
    let categories = ExerciseCategory.allCases
    @Binding var exerciseCategory : ExerciseCategory?
    @State private var id : String?
    @State private var selectedExerciseCategory : ExerciseCategory?
    @Namespace private var namespace
    
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
        .onChange(of: id) { oldValue, newValue in
            guard let newValue, let category = ExerciseCategory(rawValue: newValue) else { return }
            withAnimation {
                self.selectedExerciseCategory = category
            }
        }
    }
    
    var scrollView : some View {        
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(categories) { exerciseCategory in
                    categoryItem(exerciseCategory)
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $id)
        .scrollIndicators(.hidden)
    }
}

private extension CategoryInputView {
    func categoryItem(_ exerciseCategory : ExerciseCategory) -> some View {
        VStack {
            image(exerciseCategory.icon)
            title(exerciseCategory.rawValue)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    func title(_ title : String) -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.medium)
    }
    
    func image(_ icon : String) -> some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(height: 144)
            .foregroundStyle(.accent)
            .padding()
            .compositingGroup()
            .shadow(color: .black.opacity(0.4), radius: 4)
    }
}

// MARK: Legend
private extension CategoryInputView {
    var legend : some View {
        HStack(spacing: 16) {
            ForEach(categories) { exerciseCategory in
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
            .foregroundStyle(exerciseCategory == self.selectedExerciseCategory ? .accent : .secondary)
            .scaleEffect(exerciseCategory == self.selectedExerciseCategory ? 1.2 : 0.8)
    }
}

// MARK: Set the selected exercise category on appear
private extension CategoryInputView {
    func setExerciseCategory() {
        guard let exerciseCategory else {
            self.exerciseCategory = categories.first
            self.selectedExerciseCategory = self.exerciseCategory
            return
        }
        self.exerciseCategory = exerciseCategory
        self.selectedExerciseCategory = self.exerciseCategory
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
