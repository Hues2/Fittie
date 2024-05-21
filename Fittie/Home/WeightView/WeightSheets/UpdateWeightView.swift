import SwiftUI
import SwiftData

struct UpdateWeightView: View {
    @State private var weight : Double?
    @Bindable var todaysWeight : Weight
    
    var body: some View {
        WeightInputView(weight: $weight, saveAction: {
            saveAction()
        })
        .onAppear {
            self.weight = todaysWeight.kg
        }
    }
}

private extension UpdateWeightView {
    func saveAction() {
        guard let updatedWeight = weight else { return }
        self.todaysWeight.kg = updatedWeight
    }
}
