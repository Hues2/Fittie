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
            VStack(spacing: 12) {
                ForEach(Array(zip(0..<sets.count, sets)), id: \.0) { (index, set) in
                    SetCell(index: index + 1, kg: set.kg, reps: set.reps)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    func addSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}

#Preview {
    SetsInputView(sets: .constant([]))
}
