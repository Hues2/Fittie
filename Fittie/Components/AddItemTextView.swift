import SwiftUI

struct AddItemTextView: View {
    let title : LocalizedStringKey
    let font : Font
    
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
            Text(title)
        }
        .font(font)
        .fontWeight(.light)
        .foregroundStyle(.accent)
        .frame(maxWidth: .infinity)        
    }
}

#Preview {
    AddItemTextView(title: "Add set", font: .title)
}
