import SwiftUI

struct ExerciseCellView: View {
    let category : String
    let name : String
    let sets : [WorkingSet]
    let showExerciseName : Bool
    
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
                
//                                previewContent
                if !sets.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(Array(zip(0..<sets.count, sets)), id: \.0) { (index, set) in
                            setRow(index + 1, set.kg, set.reps)
                        }
                    }
                }
            }
            .background(Color.background)
            .cornerRadius(Constants.cornerRadius, corners: .allCorners)
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
            .frame(maxWidth: .infinity)
            
            Text("reps_unit")
                .frame(maxWidth: .infinity)
        }
        .font(.headline)
        .fontWeight(.light)
        .foregroundStyle(.pink)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding()
        .background(Constants.backgroundLightMaterial)
    }
    
    func setRow(_ set : Int, _ weight : Double, _ reps : Int) -> some View {
        VStack(spacing: 0) {
            ExerciseCellContentView(set: set,
                                weight: weight,
                                reps: reps) {
                // Delete
            }
            
            if set != sets.count {
                Divider()
            }
        }
    }
}

private extension ExerciseCellView {
    // Add this for preview
    var previewContent : some View {
        VStack(spacing: 0) {
            setRow(1, 22.5, 10)
            setRow(1, 22.5, 10)
            setRow(1, 22.5, 10)
            setRow(1, 22.5, 10)
        }
    }
}

#Preview {
    ExerciseCellView(category: "Chest",
                     name: "Dumbbell bench press",
                     sets: [],
                     showExerciseName: true)
}
