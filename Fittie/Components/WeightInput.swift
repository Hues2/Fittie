import SwiftUI

struct WeightInput<F: ParseableFormatStyle>: View where F.FormatOutput == String, F.FormatInput: Equatable {
    @FocusState private var isFocused : Bool
    @Binding var value : F.FormatInput?
    @Binding var weightIsValid : Bool
    let formatStyle: F
    let promptText : String

    
    var body: some View {
        TextField("", value: $value, format: formatStyle, prompt: Text(promptText))
            .font(.system(size: Constants.bigTextSize))
            .foregroundStyle(weightIsValid ? Color.primary : Color.red)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                self.isFocused = true
            }
            .onChange(of: value) { oldValue, newValue in
                guard newValue != nil else {
                    self.weightIsValid = false
                    return
                }
                self.weightIsValid = true
            }
    }
}

#Preview {
    WeightInput(value: .constant(86.6), weightIsValid: .constant(true), formatStyle: .number, promptText: "80.4")
}
