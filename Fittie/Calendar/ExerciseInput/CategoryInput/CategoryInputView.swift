import SwiftUI

struct CategoryInputView: View {
    let categories = ExerciseCategory.allCases
    @Binding var exerciseCategory : ExerciseCategory?
    @State private var selectedExerciseCategoryId : String?
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 32) {
                scrollView
                legend
            }
        }
        .onAppear {
            setExerciseCategory()
        }
        .onChange(of: selectedExerciseCategoryId) { oldValue, newValue in
            guard let newValue else { return }
            withAnimation {
                self.exerciseCategory = ExerciseCategory(rawValue: newValue)
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
                                .scaleEffect(phase.isIdentity ? 1 : 0.1)
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
        .padding(8)
        .padding(.horizontal, 4)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color.card)
        }        
    }
    
    func legendIcon(_ exerciseCategory : ExerciseCategory) -> some View {
        VStack {
            Color.clear
                .frame(width: 16, height: 2)
                .clipShape(.capsule)
            
            Image(exerciseCategory.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 24)
                .frame(width: 20)
                .foregroundStyle(exerciseCategory == self.exerciseCategory ? .accent : .secondary)
                .scaleEffect(exerciseCategory == self.exerciseCategory ? 1.3 : 1)
            
            if self.exerciseCategory == exerciseCategory {
                Color.accentColor
                    .frame(width: 12, height: 2)
                    .clipShape(.capsule)
                    .matchedGeometryEffect(id: "legend", in: namespace)
            } else {
                Color.clear
                    .frame(width: 16, height: 2)
                    .clipShape(.capsule)
            }
        }
        .onTapGesture {
            withAnimation {
                self.exerciseCategory = exerciseCategory
                self.selectedExerciseCategoryId = exerciseCategory.id
            }
        }
    }
}

// MARK: Set the selected exercise category on appear
private extension CategoryInputView {
    func setExerciseCategory() {
        guard let exerciseCategory else {
            self.exerciseCategory = categories.first
            self.selectedExerciseCategoryId = categories.first?.id
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
