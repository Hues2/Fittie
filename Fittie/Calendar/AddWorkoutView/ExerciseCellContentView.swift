import SwiftUI

struct ExerciseCellContentView: View {
    let set : Int
    let weight : Double
    let reps : Int
    var isLastCell : Bool = false
    let onDelete : () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            SwipeAction(isLastCell: isLastCell) {
                HStack {
                    Text(String(format: NSLocalizedString("log_workout_set_value", comment: "Set"), set))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(weight.toTwoDecimalPlacesString())")
                        .frame(maxWidth: .infinity)
                    Text("\(reps)")
                        .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity)
            } actions: {
                Action(tint: .accent, icon: "square.and.pencil") {
                    // Edit
                }
                
                Action(tint: .pink, icon: "trash.fill") {
                    // Delete
                }
            }
            .font(.title3)
            .fontWeight(.light)
//            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .padding(.vertical, 4)
            .background(Material.ultraThin)
            
            Divider()
        }
    }
}

#Preview {
    ExerciseCellContentView(set: 1, weight: 22.5, reps: 10) {
        
    }
}

#Preview {
    let sets : [WorkingSet] = [
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10),
        .init(kg: 22.5, reps: 10)
    ]
    
    return ZStack {
        Color.background.ignoresSafeArea()
        SetsInputView(sets: .constant(sets))
    }
}
