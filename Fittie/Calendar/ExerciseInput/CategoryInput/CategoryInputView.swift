import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 16) {
                ForEach(ExerciseCategory.allCases) { category in
                    CategoryInputCardView(title: category.rawValue,
                                          isSelected: exerciseCategory == category)
                    .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .onTapGesture {
                        withAnimation {
                            self.exerciseCategory = category
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 40)
            .padding(.vertical)
        }
    }
}

#Preview {
    CategoryInputView(exerciseCategory: .constant(.Chest))
}
