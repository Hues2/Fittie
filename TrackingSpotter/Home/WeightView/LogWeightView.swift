import SwiftUI
import SwiftData

struct LogWeightView: View {
    @Environment(\.modelContext) private var context
    @FocusState private var isFocused : Bool
    @State private var weight : String = ""
    @State private var weightIsValid : Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            title
            weightInput
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
    
    var saveButton : some View {
        CustomButton(title: "log_weight_save_button_title") {
            // Save weight
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true), content: {
            LogWeightView()
                .withCustomSheetHeight()
        })
}
