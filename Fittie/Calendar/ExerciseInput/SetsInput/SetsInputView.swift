import SwiftUI

struct SetsInputView: View {
    @State private var showSetInputView : Bool = false
    @Binding var sets : [WorkingSet]
    
    var body: some View {
        setsInput
            .sheet(isPresented: $showSetInputView) {
                AddSetView { set in
                    addSet(set)
                }
                .withCustomSheetHeight()
            }
    }
}

// MARK: Sets Input
private extension SetsInputView {
    var setsInput : some View {
        VStack {
            if sets.isEmpty {
                AddItemTextView(title: "log_exercise_add_set_btn_title", font: .title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.showSetInputView = true
                    }
            } else {
                VStack(spacing: 16) {
                    addedSetsView
                    AddItemTextView(title: "log_exercise_add_set_btn_title", font: .title3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showSetInputView = true
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var addedSetsView : some View {
        ScrollView {
            ExerciseCellView(category: "",
                             name: "",
                             sets: sets,
                             showExerciseName: false)
            .padding()
        }
    }
    
    func addSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}

#Preview {
    let sets : [WorkingSet] = [
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10)
    ]
    
    return SetsInputView(sets: .constant(sets))
}
