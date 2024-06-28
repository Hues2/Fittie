import SwiftUI

struct CategoryInputView: View {
    let categories = ExerciseCategory.allCases
    @Binding var exerciseCategory : ExerciseCategory?
    @State private var selectedExerciseCategoryId : String?
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
        .onChange(of: selectedExerciseCategoryId) { oldValue, newValue in
            guard let newValue, let category = ExerciseCategory(rawValue: newValue) else { return }
            withAnimation {
                self.exerciseCategory = category
            }
        }
    }
    
    var scrollView : some View {        
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(categories) { exerciseCategory in
                    categoryItem(exerciseCategory)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition { view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : 0.2)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selectedExerciseCategoryId)
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
        VStack {
            Image(exerciseCategory.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(exerciseCategory.id == self.selectedExerciseCategoryId ? .accent : .secondary)
                .scaleEffect(exerciseCategory.id == self.selectedExerciseCategoryId ? 1.2 : 0.8)
                .onTapGesture {
                    withAnimation {
                        self.selectedExerciseCategoryId = exerciseCategory.id
                    }
                }
            
            if self.selectedExerciseCategoryId == exerciseCategory.id {
                Color.accentColor
                    .frame(width: 16, height: 2)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "legend", in: namespace)
            } else {
                Color.clear
                    .frame(width: 16, height: 2)
                    .clipShape(.capsule)
            }
        }
        .animation(.smooth, value: selectedExerciseCategoryId)
    }
}

// MARK: Set the selected exercise category on appear
private extension CategoryInputView {
    func setExerciseCategory() {
        guard let exerciseCategory else {
            self.exerciseCategory = categories.first
            self.selectedExerciseCategoryId = self.exerciseCategory?.id
            return
        }
        self.exerciseCategory = exerciseCategory
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
