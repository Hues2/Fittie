import SwiftUI

struct WeightInputView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var weightIsValid : Bool = false
    @Binding var weight : Double?
    let saveAction : () -> Void
    
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

private extension WeightInputView {
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
        WeightInput(value: $weight, weightIsValid: $weightIsValid, formatStyle: .number, promptText: "80.4")
    }
    
    var kgLabel : some View {
        Text("log_weight_kg_label")
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
