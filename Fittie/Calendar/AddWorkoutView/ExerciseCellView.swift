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
                
                //                previewContent
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
            ExerciseCellContent(set: set,
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

struct ExerciseCellContent: View {
    let set: Int
    let weight: Double
    let reps: Int
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = .zero
    @State private var isDragging = false
    
    private let threshold: CGFloat = -100 // Threshold for triggering the delete action
    private let maxOffset: CGFloat = -150 // Maximum offset when fully swiped
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    withAnimation {
                        onDelete()
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Foreground content
            HStack {
                Text(String(format: NSLocalizedString("log_workout_set_value", comment: "Set"), set))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(weight.toTwoDecimalPlacesString())")
                    .frame(maxWidth: .infinity)
                Text("\(reps)")
                    .frame(maxWidth: .infinity)
            }
            .font(.title3)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.background)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isDragging = true
                        if gesture.translation.width < 0 {
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            if offset < threshold {
                                onDelete()
                            } else {
                                offset = .zero
                            }
                            isDragging = false
                        }
                    }
            )
        }
    }
}

#Preview {
    ExerciseCellContent(set: 1, weight: 22.5, reps: 10) {
        
    }
}
