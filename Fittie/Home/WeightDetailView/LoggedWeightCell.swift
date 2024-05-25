import SwiftUI

struct LoggedWeightCell: View {
    let date : Date
    let kg : Double
    var isExpanded : Bool = false
    
    var body: some View {
        VStack {
            mainCell
                .padding(.horizontal)
                .padding(.vertical, 24)
            
            if isExpanded {
                actionButtons
            }
        }
        
        .background(Material.thick)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

// MARK: Main Cell
private extension LoggedWeightCell {
    var mainCell : some View {
        HStack {
            HStack {
                Image(systemName: "scalemass")
                    .foregroundStyle(.pink)
                Text(kg.toTwoDecimalPlacesString() + NSLocalizedString("log_weight_kg_label", comment: "Kg unit"))
            }
            .font(.title3)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(date.formattedWithOrdinalSuffix())
                .font(.headline)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: Buttons
private extension LoggedWeightCell {
    var actionButtons : some View {
        HStack(spacing: 0) {
            button(title: "weight_detail_view_logged_weight_cell_edit",
                   color: .orange,
                   corner: .bottomLeft,
                   alignment: .leading) {
                // Edit action
            }
            
            button(title: "weight_detail_view_logged_weight_cell_delete",
                   color: .red,
                   corner: .bottomRight,
                   alignment: .trailing) {
                // Edit action
            }
        }
    }
    
    func button(title : LocalizedStringKey,
                color : Color,
                corner : UIRectCorner,
                alignment : Alignment,
                _ action : @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    color
                        .cornerRadius(Constants.cornerRadius, corners: [corner])
                )
        }
        .frame(maxWidth: .infinity, alignment: alignment)
    }
}

#Preview {
    VStack {
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
        LoggedWeightCell(date: .now, kg: 86.8)
    }
}
