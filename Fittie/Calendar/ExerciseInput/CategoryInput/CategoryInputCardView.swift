import SwiftUI

struct CategoryInputCardView: View {
    let icon : String
    let title: String
    let isSelected : Bool
    
    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 72)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        
        .background(Constants.backgroundMaterial)
        .cornerRadius(Constants.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? .accent : .clear)
        }
    }
}

#Preview {
    VStack {
        CategoryInputCardView(icon: "chest_category", title: "Chest", isSelected: true)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "shoulders_category", title: "Shoulders", isSelected: true)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "arms_category", title: "Arms", isSelected: true)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "legs_category", title: "Legs", isSelected: true)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "back_category", title: "Back", isSelected: true)
            .frame(height: 100)
            .padding()
    }
}
