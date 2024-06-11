import SwiftUI

struct ExerciseCellContentView: View {
    let set : Int
    let weight : Double
    let reps : Int
    let onDelete : () -> Void
    
    @State private var offset: CGFloat = .zero
    @State private var previousTranslation: CGFloat = .zero
    @State private var isDragging = false
    
    private let maxOffset : CGFloat = -150 // Maximum offset when fully swiped
    private let iconWidth : CGFloat = 88
    
    var body: some View {
        ZStack {
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash.fill")
                    .font(.headline)
                    .foregroundStyle(Color.background)
                    .padding()
                    .frame(width: iconWidth)
                    .background(.pink)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
                        
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
                        print("current offset \(offset)")
                        print(gesture.translation.width)
                        print("previous translation \(previousTranslation)")
                            if offset < gesture.translation.width {
                                let amountToMove = gesture.translation.width - previousTranslation
                                offset = min(0, (offset + amountToMove))
                                previousTranslation = gesture.translation.width
                            } else {
                                offset = min(0, gesture.translation.width)
                                previousTranslation = .zero
                            }
                    }
                    .onEnded { _ in
                        withAnimation(.snappy) {
                            if (offset < -(iconWidth + 12)) {
                                // Set the offset to show the delete button
                                offset = -(iconWidth + 12)
                                print("Show delete button")
                            } else {
                                print("Reset offset")
                                offset = .zero
                            }
                        }
                        self.isDragging = false
                        self.previousTranslation = .zero
                    }
            )
        }
    }
}

#Preview {
    ExerciseCellContentView(set: 1, weight: 22.5, reps: 10) {
        
    }
}
