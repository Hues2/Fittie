import SwiftUI

struct ExerciseCellView: View {
    let category : String
    let name : String
    let sets : [WorkingSet]
    let showExerciseName : Bool
    let showDeleteButton : Bool
    var onDeleteSet : ((Int) -> Void)? = nil
    var onEditSet : ((Int) -> Void)? = nil
    var onDeleteExercise : (() -> Void)? = nil
    
    var body: some View {
        cellContent
    }
}

private extension ExerciseCellView {
    var cellContent : some View {
        VStack {
            if showExerciseName || showDeleteButton {
                titleAndDeleteButton
            }
            
            VStack(spacing: 0) {
                setRowHeader
                
                if !sets.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(sets.sorted { $0.number < $1.number }) { set in
                            ExerciseCellContentView(setNumber: set.number,
                                                    weight: set.kg,
                                                    reps: set.reps,
                                                    isLastCell: set.id == sets.last?.id,
                                                    isScrollDisabled: (onDeleteSet == nil)) {
                                // Delete
                                // set.number - 1, will represent the index of the item
                                onDeleteSet?(set.number - 1)
                            } onEditSet: {
                                // Edit
                                // set.number - 1, will represent the index of the item
                                onEditSet?(set.number - 1)
                            }
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
    
    var titleAndDeleteButton : some View {
        HStack {
            nameAndCategoryView
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if showDeleteButton {
                deleteButton
                    .padding(.horizontal, 8)
            }
        }
    }
    
    var deleteButton : some View {
        IconButton(icon: "trash", color: Color.secondaryAccent, showBorder: false) {
            onDeleteExercise?()
        }
    }
    
    var nameAndCategoryView : some View {
        // Is in an HStack no ensure that is pushes the delete button to the trailing side
        HStack {
            if showExerciseName {
                Text(name.capitalized + " (\(category))")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var setRowHeader : some View {
        HStack(spacing: 0) {
            Text("")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(String(format: NSLocalizedString("log_exercise_add_set_weight_title", comment: "Weight title"),
                        NSLocalizedString("kg_unit", comment: "Kg")))
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("reps_unit")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.headline)
        .fontWeight(.light)
        .foregroundStyle(Color.secondaryAccent)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding()
        .background(Color.lightCard)
    }
}

#Preview {
    let sets : [WorkingSet] = [
        .init(number: 1, kg: 22.5, reps: 10),
        .init(number: 2, kg: 22.5, reps: 10),
        .init(number: 3, kg: 22.5, reps: 10),
        .init(number: 4, kg: 22.5, reps: 10)
    ]
    
    return ExerciseCellView(category: "Chest",
                            name: "Dumbbell bench press",
                            sets: sets,
                            showExerciseName: true,
                            showDeleteButton: true) { _ in
    }
}

#Preview {
    let sets : [WorkingSet] = [
        .init(number: 1, kg: 22.5, reps: 10),
        .init(number: 2, kg: 22.5, reps: 10),
        .init(number: 3, kg: 22.5, reps: 10),
        .init(number: 4, kg: 22.5, reps: 10)
    ]
    
    return SetsInputView(sets: .constant(sets))
}
