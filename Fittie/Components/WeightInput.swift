import SwiftUI

struct WeightInput<F: ParseableFormatStyle>: View where F.FormatOutput == String, F.FormatInput: Equatable {
    @Binding var value : F.FormatInput?
    @Binding var weightIsValid : Bool
    @FocusState.Binding var isFocused : Bool
    let formatStyle: F
    let promptText : String

    
    var body: some View {
        TextField("", value: $value, format: formatStyle, prompt: Text(promptText))
            .font(.system(size: Constants.bigTextInputTextSize))
            .foregroundStyle(weightIsValid ? Color.primary : Color.red)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .center)            
            .onChange(of: value) { oldValue, newValue in
                guard newValue != nil else {
                    self.weightIsValid = false
                    return
                }
                self.weightIsValid = true
            }
    }
}
