import SwiftUI

struct StepCountView: View {
    @State private var showSheet : Bool = false
    let steps : Int?
    let stepTarget : Int?
    let changeStepTarget : () -> Void
    
    var body: some View {
        card
            .onTapGesture {
                self.showSheet = true                
            }
            .sheet(isPresented: $showSheet, content: {
                Text("Change step target")
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
            })
    }
}

private extension StepCountView {
    var card : some View {
        VStack(spacing: 16) {
            title
            
            VStack {
                valueView("current_steps_title", steps)
                valueView("target_steps_title", stepTarget)
            }
        }
        .foregroundStyle(Color.customWhite)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.darkGray)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    var title : some View {
        HStack {
            Text("steps_title")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "figure.walk")
                .foregroundStyle(.accent)
                .font(.title)
        }
    }
    
    @ViewBuilder func valueView(_ title : LocalizedStringKey, _ value : Int?) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            Group {
                if let value {
                    Text("\(value)")
                } else {
                    Text("-")
                }
            }
            .font(.title3)
            .fontWeight(.light)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    StepCountView(steps: 337, stepTarget: 10000) {
        
    }
}
