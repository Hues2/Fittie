import SwiftUI
import SwiftData

struct LogWeightView: View {
    @Environment(\.modelContext) private var context
    @State private var weight : Double?
    
    var body: some View {
        WeightInputView(weight: $weight, saveAction: {
            saveAction()
        })
    }
}

private extension LogWeightView {
    func saveAction() {        
        guard let weight else { return }
        let newWeight = Weight(date: .now.startOfDay, kg: weight)
        context.insert(newWeight)
    }
    
    func addMockWeights() {
        let newWeight1 = Weight(date: Date.getDayFrom(date: .now, days: 1)!, kg: 87)
        let newWeight2 = Weight(date: Date.getDayFrom(date: .now, days: 3)!, kg: 83)
        let newWeight3 = Weight(date: Date.getDayFrom(date: .now, days: 5)!, kg: 90)
        
        let newWeight4 = Weight(date: Date.getDayFrom(date: .now, days: 8)!, kg: 87)
        let newWeight5 = Weight(date: Date.getDayFrom(date: .now, days: 12)!, kg: 83)
        let newWeight6 = Weight(date: Date.getDayFrom(date: .now, days: 15)!, kg: 90)
        
        let newWeight7 = Weight(date: Date.getDayFrom(date: .now, days: 137)!, kg: 87)
        let newWeight8 = Weight(date: Date.getDayFrom(date: .now, days: 165)!, kg: 83)
        let newWeight9 = Weight(date: Date.getDayFrom(date: .now, days: 196)!, kg: 90)
        
        let newWeight10 = Weight(date: Date.getDayFrom(date: .now, days: 203)!, kg: 87)
        let newWeight11 = Weight(date: Date.getDayFrom(date: .now, days: 270)!, kg: 83)
        let newWeight12 = Weight(date: Date.getDayFrom(date: .now, days: 365)!, kg: 90)
        
        context.insert(newWeight1)
        context.insert(newWeight2)
        context.insert(newWeight3)
        
        context.insert(newWeight4)
        context.insert(newWeight5)
        context.insert(newWeight6)
        
        context.insert(newWeight7)
        context.insert(newWeight8)
        context.insert(newWeight9)
        
        context.insert(newWeight10)
        context.insert(newWeight11)
        context.insert(newWeight12)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            LogWeightView()
                .withCustomSheetHeight()
        })
}
