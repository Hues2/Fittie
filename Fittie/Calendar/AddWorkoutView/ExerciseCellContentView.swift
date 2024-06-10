import SwiftUI

struct ExerciseCellContentView: View {
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
            Button(action: {
                withAnimation(.snappy) {
                    onDelete()
                }
            }) {
                Image(systemName: "trash.fill")
                    .foregroundStyle(Color.background)
                    .padding()
                    .background(.pink)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
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
            .background(Constants.backgroundMaterial)
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
                        withAnimation(.snappy) {
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
    ExerciseCellContentView(set: 1, weight: 22.5, reps: 10) {
        
    }
}
