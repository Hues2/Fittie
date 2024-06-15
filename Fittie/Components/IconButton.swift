import SwiftUI

struct IconButton: View {
    let icon : String
    let color : Color
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(color)
                )
                .foregroundStyle(color)
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    IconButton(icon: "trash", color: Color.secondaryAccent) {
        
    }
}
