import SwiftUI
import SwiftData

struct LogWeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var isFocused : Bool
    @State private var weight : String = ""
    @State private var weightIsValid : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            title
            inputWithLabel
            saveButton
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .padding(.top, 24)        
    }
}

private extension LogWeightView {
    var title : some View {
        Text("log_weight_view_title")
            .font(.title)
            .fontWeight(.bold)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var inputWithLabel : some View {
        VStack {
            weightInput
            kgLabel
        }
    }
    
    var weightInput : some View {
        TextField(text: $weight, prompt: Text("80.4")) { }
            .font(.system(size: Constants.bigTextSize))
            .foregroundStyle(weightIsValid ? Color.primary : Color.red)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                self.isFocused = true
            }
            .onChange(of: weight) { oldValue, newValue in
                guard Double(weight) != nil else {
                    self.weightIsValid = false
                    return
                }
                self.weightIsValid = true
            }
    }
    
    var kgLabel : some View {
        Text("log_weight_kg_label")
            .font(.title2)
            .foregroundStyle(.secondary)
    }
    
    var saveButton : some View {
        CustomButton(title: "log_weight_save_button_title") {
            // Save weight
            guard let weightDouble = Double(weight), weightIsValid else { return }
            let weight = Weight(date: .now, kg: weightDouble)
            let weight1 = Weight(date: Date.getDayFrom(date: .now, days: 1)!, kg: 72)
            let weight2 = Weight(date: Date.getDayFrom(date: .now, days: 3)!, kg: 74)
            let weight3 = Weight(date: Date.getDayFrom(date: .now, days: 6)!, kg: 79)
            let weight4 = Weight(date: Date.getDayFrom(date: .now, days: 9)!, kg: 73)
//            context.insert(weight)
            context.insert(weight1)
            context.insert(weight2)
            context.insert(weight3)
            context.insert(weight4)
            dismiss()
        }
        .disabled(!self.weightIsValid)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            LogWeightView()
                .withCustomSheetHeight()
        })
}
