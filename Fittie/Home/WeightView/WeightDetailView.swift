import SwiftUI

struct WeightDetailView: View {
    @ObservedObject var viewModel : HomeViewModel
    var namespace : Namespace.ID
    
    var body: some View {
        VStack {
            WeightView(weightGoal: $viewModel.weightGoal)
                .matchedGeometryEffect(id: "weight_view", in: namespace)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, Constants.horizontalScrollviewPadding)
        }
    }
}
