import SwiftUI

struct WeightInput<F: ParseableFormatStyle>: View where F.FormatOutput == String, F.FormatInput: Equatable {
    @Binding var value : F.FormatInput?
    @Binding var weightIsValid : Bool
    @FocusState.Binding var isFocused : Bool
    let formatStyle: F
    let promptText : String
    var useBigFontSize : Bool = true

    
    var body: some View {
        TextField("", value: $value, format: formatStyle, prompt: Text(promptText))
            .font(useBigFontSize ? .system(size: Constants.bigTextInputTextSize) : .title2)
            .foregroundStyle(weightIsValid ? Color.primary : Color.red)
            .multilineTextAlignment(.center)
            .keyboardType(.decimalPad)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .center)            
            .onChange(of: value) { oldValue, newValue in
                verifyValue(newValue)
            }
            .onAppear {
                verifyValue(value)
            }
    }
    
    private func verifyValue(_ value : F.FormatInput?) {
        guard value != nil else {
            self.weightIsValid = false
            return
        }
        self.weightIsValid = true
    }
}
