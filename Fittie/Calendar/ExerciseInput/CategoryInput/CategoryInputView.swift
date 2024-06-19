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
                ForEach(ExerciseCategory.allCases) { category in
                    CategoryInputCardView(icon: category.icon,
                                          title: category.rawValue,
                                          isSelected: exerciseCategory == category)
                    .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .onTapGesture {
                        self.exerciseCategory = category
                    }
                }
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
