import SwiftUI

struct LoggedWeightCell: View {
    let date : Date
    let kg : Double
    let deleteAction : () -> Void
    let editAction : () -> Void
    
    var body: some View {
        VStack {
            cell
                .padding(.horizontal)
                .padding(.vertical, 24)
        }
        
        .background(Material.thick)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

// MARK: Main Cell
private extension LoggedWeightCell {
    var cell : some View {
        HStack {
            HStack {
                Image(systemName: "scalemass")
                    .foregroundStyle(.pink)
                    .font(.title)
                    .fontWeight(.regular)
                VStack(alignment: .leading) {
                    Text(kg.toTwoDecimalPlacesString() + NSLocalizedString("log_weight_kg_label", comment: "Kg unit"))
                        .font(.title3)
                        .fontWeight(.regular)
                    Text(date.formattedWithOrdinalSuffix())
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            actionButtons
        }
    }
}

// MARK: Buttons
private extension LoggedWeightCell {
    var actionButtons : some View {
        HStack(spacing: 12) {
            button(icon: "square.and.pencil", color: .accent) {
                editAction()
            }
            
            button(icon: "trash", color: .pink) {
                deleteAction()
            }
        }
    }
    
    func button(icon : String,
                color : Color,
                _ action : @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke()
                )
                .foregroundStyle(color)
                .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

#Preview {
    VStack {
        LoggedWeightCell(date: .now, kg: 86.6) {
            
        } editAction: {
            
        }

    }
}
