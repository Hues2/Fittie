import SwiftUI

// MARK: This view is used to edit/add exercises
struct ExerciseInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    @Binding var exerciseName : String
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            content
                .padding(.top, 12)
        }
    }
}

private extension ExerciseInputView {
    var content : some View {
        VStack {
            title
            
            ScrollView {
                VStack {
                    
                }
            }
        }
        .padding()
    }
    
    var title : some View {
        Text("log_exercise_title")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ExerciseInputView(exerciseCategory: .constant(.Arms), exerciseName: .constant("Bench Press"))
}
