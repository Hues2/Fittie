import SwiftUI

struct ExerciseCellView: View {
    let category : String
    let name : String
    let sets : [WorkingSet]
    let showExerciseName : Bool
    var onDeleteSet : ((Int) -> Void)? = nil
    var onEditSet : ((Int) -> Void)? = nil
    
    var body: some View {
        cellContent
    }
}

private extension ExerciseCellView {
    var cellContent : some View {
        VStack {
            if showExerciseName {
                nameAndCategoryView
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
    
    var nameAndCategoryView : some View {
        Text(name.capitalized + " (\(category))")
            .font(.headline)
            .fontWeight(.light)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
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
        .background(Constants.backgroundLightMaterial)
    }
}

private extension ExerciseCellView {
    // Add this for preview
    var previewContent : some View {
        VStack(spacing: 0) {
            ExerciseCellContentView(setNumber: 1,
                                    weight: 22.5,
                                    reps: 10,
                                    isScrollDisabled: false) {
                
            } onEditSet: {
                
            }
            ExerciseCellContentView(setNumber: 1,
                                    weight: 22.5,
                                    reps: 10,
                                    isScrollDisabled: false) {
                
            } onEditSet: {
                
            }
            ExerciseCellContentView(setNumber: 1,
                                    weight: 22.5,
                                    reps: 10,
                                    isScrollDisabled: false) {
                
            } onEditSet: {
                
            }
            ExerciseCellContentView(setNumber: 1,
                                    weight: 22.5,
                                    reps: 10,
                                    isScrollDisabled: false) {
                
            } onEditSet: {
                
            }
        }
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
                            showExerciseName: true) { _ in
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
