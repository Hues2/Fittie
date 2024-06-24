import SwiftUI

struct CategoryInputCardView: View {
    let exerciseCategory : ExerciseCategory
    @Binding var selectedExerciseCategory : ExerciseCategory?
    @State private var isSelected : Bool = false
    
    init(exerciseCategory: ExerciseCategory, selectedExerciseCategory: Binding<ExerciseCategory?>) {
        self.exerciseCategory = exerciseCategory
        self._selectedExerciseCategory = selectedExerciseCategory
        withAnimation {
            self.isSelected = (selectedExerciseCategory.wrappedValue == exerciseCategory)
        }                
    }
    
    var body: some View {
        VStack {
            image
            title
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? .accent : .clear, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .onTapGesture {
            self.selectedExerciseCategory = exerciseCategory            
        }
        .onChange(of: selectedExerciseCategory) { oldValue, newValue in
            withAnimation(.smooth) {
                self.isSelected = (selectedExerciseCategory == exerciseCategory)
            }
        }
        .padding()
        .scrollTransition { view, phase in
            view
                .scaleEffect(phase.isIdentity ? 1 : 0.3)
                .opacity(phase.isIdentity ? 1 : 0.5)                
        }
    }
}

private extension CategoryInputCardView {
    var title : some View {
        Text(exerciseCategory.rawValue)
            .font(.title)
            .fontWeight(.light)
            .padding()
    }
    
    var image : some View {
        Image(exerciseCategory.icon)
            .resizable()
            .scaledToFit()
            .frame(height: 144)
            .foregroundStyle(.accent)
            .padding()
            .compositingGroup()
            .shadow(color: .black.opacity(0.4), radius: 4)
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
