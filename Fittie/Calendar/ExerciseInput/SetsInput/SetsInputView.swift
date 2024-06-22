import SwiftUI

struct SetsInputView: View {
    @State private var showSetInputView : Bool = false
    @Binding var sets : [WorkingSet]
    @State private var setToBeUpdated : WorkingSet?
    
    var body: some View {
        setsInput
            .sheet(isPresented: $showSetInputView) {
                AddSetSheet(setNumber: sets.count + 1) { set in
                    addSet(set)
                }
                .withCustomSheetHeight()
            }
            .sheet(item: $setToBeUpdated) { workingSet in
                AddSetSheet(setNumber: workingSet.number,
                            weight: workingSet.kg,
                            reps: Double(workingSet.reps)) { workingSet in
                    updateSet(workingSet)
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
                             showExerciseName: false,
                             showDeleteButton: false,
                             onDeleteSet: { index in
                // Delete set
                self.deleteSet(index)
            }, onEditSet: { index in
                self.selectSetToBeUpdated(index)
            })
            .padding(.horizontal, 8)
        }
        .scrollIndicators(.hidden)
    }
    
    func addSet(_ set : WorkingSet) {
        withAnimation(sets.isEmpty ? .none : .snappy) {
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

// MARK: Edit set functionality
private extension SetsInputView {
    func selectSetToBeUpdated(_ index : Int) {
        let workingSet = sets[safe: index]
        self.setToBeUpdated = workingSet
    }
    
    func updateSet(_ workingSet : WorkingSet) {
        let index = self.sets.firstIndex { $0.number == workingSet.number }
        guard let index, sets.indices.contains(index) else { return }
        self.sets[index].kg = workingSet.kg
        self.sets[index].reps = workingSet.reps
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
