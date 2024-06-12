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
                             .padding(.horizontal, 8)
        }
        .scrollIndicators(.hidden)
    }
    
    func addSet(_ set : WorkingSet) {
        withAnimation {
            self.sets.append(set)
        }
    }
}

// MARK: Delete set functionality
private extension SetsInputView {
    func deleteSet(_ index : Int) {
        withAnimation {
            // Remove the selected set
            self.sets.remove(at: index)
            
            // Reset the sets number
            self.sets = self.sets.sorted { $0.number < $1.number }.enumerated().map { (index, set) in
                var newSet = set
                newSet.number = index + 1
                return newSet
            }
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
