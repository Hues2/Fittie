import SwiftUI

struct CategoryInputView: View {
    @Binding var exerciseCategory : ExerciseCategory
    
    var body: some View {
        VStack(spacing: 16) {
            InputTitle(title: "log_exercise_category_title")
            
            Picker("", selection: $exerciseCategory) {
                ForEach(ExerciseCategory.allCases.sorted(by: { $0.rawValue < $1.rawValue })) { category in
                    Text(category.rawValue)
                        .tag(category)
                }
            }
            .pickerStyle(.segmented)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
