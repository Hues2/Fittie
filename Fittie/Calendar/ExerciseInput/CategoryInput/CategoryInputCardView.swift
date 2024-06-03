import SwiftUI

struct CategoryInputCardView: View {
    let title: String
    let isSelected : Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
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
    VStack {
        CategoryInputCardView(title: "Chest", isSelected: true)
            .frame(height: 150)
            .padding()
        CategoryInputCardView(title: "Chest", isSelected: true)
            .frame(height: 150)
            .padding()
        CategoryInputCardView(title: "Chest", isSelected: true)
            .frame(height: 150)
            .padding()
        CategoryInputCardView(title: "Chest", isSelected: true)
            .frame(height: 150)
            .padding()
        CategoryInputCardView(title: "Chest", isSelected: true)
            .frame(height: 150)
            .padding()
    }
}
