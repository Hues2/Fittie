import SwiftUI

struct SetsInputView: View {
    @State private var showSetInputView : Bool = false
    @Binding var sets : [WorkingSet]
    
    var body: some View {
        setsInput
            .sheet(isPresented: $showSetInputView) {
                AddSetView { set in
                    saveSet(set)
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
                addSetText(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        self.showSetInputView = true
                    }
            } else {
                VStack(spacing: 16) {
                    addedSetsView
                    addSetText(.title3)
                        .onTapGesture {
                            self.showSetInputView = true
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func addSetText(_ font : Font) -> some View {
        HStack {
            Image(systemName: "plus.circle.fill")
            Text("Add set")
        }
        .font(font)
        .fontWeight(.semibold)
        .foregroundStyle(.accent)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
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
    
    func saveSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}

#Preview {
    SetsInputView(sets: .constant([]))
}
