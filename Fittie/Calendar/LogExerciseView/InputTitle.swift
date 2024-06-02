import SwiftUI

struct InputTitle: View {
    let title : LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
            .foregroundStyle(.pink)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InputTitle(title: "Hello")
}
