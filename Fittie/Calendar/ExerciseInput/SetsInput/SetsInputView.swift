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
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add set")
                }
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    self.showSetInputView = true
                }
            } else {
                VStack(spacing: 16) {
                    addedSetsView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            if !sets.isEmpty {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
                    .padding()
                    .padding(.top, 16) // Same padding values as the InputTitle used above the tabview
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.showSetInputView = true
                    }
            }
        }
    }
    
    var addedSetsView : some View {
        VStack {
            ScrollView {
                ForEach(Array(zip(0..<sets.count, sets)), id: \.0) { (index, set) in
                    SetCell(index: index + 1, kg: set.kg, reps: set.reps)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func saveSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}

#Preview {
    SetsInputView(sets: .constant([]))
}
