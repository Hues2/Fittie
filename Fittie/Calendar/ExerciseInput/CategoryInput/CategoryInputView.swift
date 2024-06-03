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
            .padding()
        }
    }
}

#Preview {
    CategoryInputView(exerciseCategory: .constant(.Chest))
}
