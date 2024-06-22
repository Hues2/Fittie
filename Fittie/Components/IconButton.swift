import SwiftUI

struct IconButton: View {
    let icon : String
    var font : Font = .body
    let color : Color
    var showBorder : Bool = true
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .font(font)
                .padding(showBorder ? 12 : 0)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(showBorder ? color : .clear)
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
