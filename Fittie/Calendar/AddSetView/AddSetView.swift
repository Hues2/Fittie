import SwiftUI

struct AddSetView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusState
    @State private var weight : Double?
    @State private var weightIsValid : Bool = false
    @State private var reps : Double?
    @State private var repsAreValid : Bool = false
    
    let saveSet : (WorkingSet) -> Void
    
    var body: some View {
        content
            .padding()
            .padding(.top, 40)
    }
}

private extension AddSetView {
    var content : some View {
        VStack(spacing: 32) {
            inputRow(String(format: NSLocalizedString("log_exercise_add_set_weight_title", comment: "Weight"),
                            NSLocalizedString("log_weight_kg_label", comment: "Weight unit")),
                     $weight,
                     $weightIsValid,
                     NSLocalizedString("log_exercise_add_set_weight_prompt", comment: "Prompt"))
            
            inputRow(NSLocalizedString("log_exercise_add_set_reps_title", comment: "Weight"),
                     $reps,
                     $repsAreValid,
                     NSLocalizedString("log_exercise_add_set_reps_prompt", comment: "Prompt"))
            
            CustomButton(title: "log_exercise_add_set_btn_title") {
                guard let weight, let reps else { return }
                saveSet(WorkingSet(kg: weight, reps: Int(reps)))
                dismiss()
            }
            .padding(.top, 12)
            .disabled(!weightIsValid || !repsAreValid)
        }
    }
    
    func inputRow(_ title : String,
                  _ value : Binding<Double?>,
                  _ isValid : Binding<Bool>,
                  _ prompt : String) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            WeightInput(value: value,
                        weightIsValid: isValid,
                        isFocused: $focusState,
                        formatStyle: .number,
                        promptText: NSLocalizedString(prompt, comment: "Textfield prompt"),
                        useBigFontSize: false)
        }
        .font(.title2)
    }
}

#Preview {
    AddSetView { _ in
        
    }
}
