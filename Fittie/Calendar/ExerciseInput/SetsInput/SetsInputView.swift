import SwiftUI

struct SetsInputView: View {
    @State private var showSetInputView : Bool = false
    @Binding var sets : [WorkingSet]
    
    var body: some View {
        setsInput
            .sheet(isPresented: $showSetInputView) {
                AddSetView(setNumber: sets.count + 1) { set in
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
                             showExerciseName: false) { index in
                // Delete Set
                self.deleteSet(index)
            }
            .padding()
        }
    }
    
    func addSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}

// MARK: Delete set functionality
private extension SetsInputView {
    func deleteSet(_ index : Int) {
        // Remove the selected set
        self.sets.remove(at: index)
        
        // Reset the sets number
        self.sets = Array(self.sets).enumerated().map { (index, set) in
            WorkingSet(number: index + 1, kg: set.kg, reps: set.reps)
        }
    }
}

#Preview {
    let sets : [WorkingSet] = [
        .init(number: 1, kg: 22.5, reps: 10),
        .init(number: 2, kg: 22.5, reps: 10),
        .init(number: 3, kg: 22.5, reps: 10),
        .init(number: 4, kg: 22.5, reps: 10)
    ]
    
    return SetsInputView(sets: .constant(sets))
}
