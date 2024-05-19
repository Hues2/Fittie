import SwiftUI
import SwiftData

struct LogWeightView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @FocusState private var isFocused : Bool
    @State private var weight : Double?
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
        TextField("", value: $weight, format: .number, prompt: Text("80.4"))
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
                guard weight != nil else {
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
            guard let weight, weightIsValid else { return }
            let newWeight = Weight(date: .now.startOfDay, kg: weight)
            context.insert(newWeight)            
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
