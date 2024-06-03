import SwiftUI

struct CategoryInputCardView: View {
    let title: String
    let isSelected : Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        
        .background(Constants.backgroundMaterial)
        .cornerRadius(Constants.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? .accent : .clear)
        }
        .compositingGroup()
        .shadow(color: isSelected ? .accent : .clear, radius: 2, x: 0, y: 0)
        .shadow(color: isSelected ? .accent : .clear, radius: 2, x: 0, y: 0)
    }
}

#Preview {
    CategoryInputCardView(title: "Chest", isSelected: true)
}
