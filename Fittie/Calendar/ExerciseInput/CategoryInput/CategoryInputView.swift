import SwiftUI

struct CategoryInputView: View {
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
    }
    
    var scrollView : some View {        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(ExerciseCategory.allCases) { exerciseCategory in
                    categoryItem(exerciseCategory)
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
            withAnimation {
                self.exerciseCategory = ExerciseCategory(rawValue: newValue)
            }
        }
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
        VStack {
            Image(exerciseCategory.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(exerciseCategory.id == selectedExerciseCategoryId ? .accent : .secondary)
            
            if exerciseCategory.id == self.exerciseCategory?.id {
                Color.accentColor
                    .frame(width: 16, height: 2)
                    .clipShape(.rect(cornerRadius: Constants.cornerRadius))
                    .matchedGeometryEffect(id: "legend_selection", in: namespace, anchor: .center)
            } else {
                Color.clear
                    .frame(width: 16, height: 2)
                    .clipShape(.rect(cornerRadius: Constants.cornerRadius))
            }
        }
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
