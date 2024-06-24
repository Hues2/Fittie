import SwiftUI

struct CategoryInputCardView: View {
    let exerciseCategory : ExerciseCategory
    
    var body: some View {
        VStack {
            image
            title
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

private extension CategoryInputCardView {
    var title : some View {
        Text(exerciseCategory.rawValue)
            .font(.title)
            .fontWeight(.medium)            
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
