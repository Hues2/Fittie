import SwiftUI

struct CategoryInputCardView: View {
    let exerciseCategory : ExerciseCategory
    @Binding var selectedExerciseCategory : ExerciseCategory?
    @State private var isSelected : Bool = false
    
    var body: some View {
        HStack {
            image
            title
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke((selectedExerciseCategory == exerciseCategory) ? .accent : .clear, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .onTapGesture {
            withAnimation(.easeInOut) {
                self.selectedExerciseCategory = exerciseCategory
            }
        }
        .onAppear {
            withAnimation {
                self.isSelected = (selectedExerciseCategory == exerciseCategory)
            }
        }
        .onChange(of: selectedExerciseCategory) { oldValue, newValue in
            withAnimation {
                self.isSelected = (selectedExerciseCategory == exerciseCategory)
            }
        }
    }
}

private extension CategoryInputCardView {
    var title : some View {
        Text(exerciseCategory.rawValue)
            .font(.title2)
            .fontWeight(.light)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder var image : some View {
        if isSelected {
            Image(exerciseCategory.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .frame(maxHeight: .infinity, alignment: .leading)
                .foregroundStyle(.accent)
                .padding()
                .background(Color.lightCard)
                .cornerRadius(Constants.cornerRadius, corners: .allCorners)
                .compositingGroup()
                .shadow(radius: 4)
                .transition(.move(edge: .leading))
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
