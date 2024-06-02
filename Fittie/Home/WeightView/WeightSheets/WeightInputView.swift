import SwiftUI

struct WeightInputView: View {
    @Environment(\.dismiss) private var dismiss
    let title : LocalizedStringKey
    @FocusState private var isFocused : Bool
    @State private var weightIsValid : Bool = true
    @Binding var weight : Double?
    let saveAction : () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            titleText
            inputWithLabel
            saveButton
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .padding(.top, 24)
        .onAppear {
            self.isFocused = true
        }
    }
}

private extension WeightInputView {
    var titleText : some View {
        Text(title)
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
        WeightInput(value: $weight, weightIsValid: $weightIsValid, isFocused: $isFocused, formatStyle: .number, promptText: "80.4")
    }
    
    var kgLabel : some View {
        Text("kg_unit")
            .font(.title2)
            .foregroundStyle(.secondary)
    }
    
    var saveButton : some View {
        CustomButton(title: "log_weight_save_button_title") {
            // Save weight
            guard weightIsValid else { return }
            saveAction()
            dismiss()
        }
        .disabled(!self.weightIsValid)
    }
}
