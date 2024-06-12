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
                .frame(width: 80)
                .frame(alignment: .leading)
                .foregroundStyle(isSelected ? .accent : .secondary)
                .padding()
                .background(Constants.backgroundLightMaterial)
            
            Text(title)
                .font(.title2)                
                .fontWeight(.light)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        
        .background(Constants.backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))        
        .overlay {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? .accent : .clear)
        }
    }
}

#Preview {
    VStack {
        CategoryInputCardView(icon: "chest_category", title: "Chest", isSelected: false)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "shoulders_category", title: "Shoulders", isSelected: true)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "arms_category", title: "Arms", isSelected: false)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "legs_category", title: "Legs", isSelected: false)
            .frame(height: 100)
            .padding()
        CategoryInputCardView(icon: "back_category", title: "Back", isSelected: false)
            .frame(height: 100)
            .padding()
    }
}
