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
        VStack(spacing: 16) {
            setsInputHeader
            addedSetsView
        }
    }
    
    var setsInputHeader : some View {
        HStack {
            InputTitle(title: "log_exercise_sets_title")
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundStyle(.accent)
        }
        .onTapGesture {
            self.showSetInputView = true
        }
    }
    
    var addedSetsView : some View {
        ForEach(Array(zip(0..<sets.count, sets)), id: \.0) { (index, set) in
            setCell(index + 1, set)
        }
    }
    
    func setCell(_ index : Int, _ set : WorkingSet) -> some View {
        HStack {
            Text("Set \(index)")
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("Weight: \(set.kg.toTwoDecimalPlacesString())")
                Text("Reps: \(set.reps)")
            }
        }
        .padding()
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    func saveSet(_ set : WorkingSet) {
        self.sets.append(set)
    }
}
