import SwiftUI

struct StepCountView: View {
    @State private var presentSheet: Bool = false
    @State private var detentHeight: CGFloat = 0
    
    let steps : Int?
    @Binding var stepGoal : Int
    
    var body: some View {
        VStack {
            title
            card
                .onTapGesture {
                    self.presentSheet = true
                }
                .sheet(isPresented: $presentSheet, content: {
                    UpdateStepTargetView(stepGoal: $stepGoal)
                        .presentationCornerRadius(Constants.sheetCornerRadius)
                        .readHeight()
                        .onPreferenceChange(HeightPreferenceKey.self) { height in
                            if let height {
                                self.detentHeight = height
                            }
                        }
                        .presentationDetents([.height(self.detentHeight)])
                })
        }
    }
}

private extension StepCountView {
    var card : some View {
        VStack(spacing: 12) {
            valueView("current_steps_title", steps, "figure.walk")
            valueView("target_steps_title", stepGoal, "target")
        }
        .foregroundStyle(Color.customWhite)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.darkGray)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    var title : some View {
        Text("steps_title")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder func valueView(_ title : LocalizedStringKey,
                                _ value : Int?,
                                _ icon : String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.medium)
                Image(systemName: icon)
                    .foregroundStyle(.accent)
                    .font(.title)
            }
            
            Group {
                if let value {
                    Text("\(value)")
                } else {
                    Text("-")
                }
            }
            .font(.title2)
            .fontWeight(.light)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HStack {
        StepCountView(steps: 337, stepGoal: .constant(10000))
        Spacer()
            .frame(width: 175)
    }
}
