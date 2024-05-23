import SwiftUI

struct WeightDetailView: View {
    @ObservedObject var viewModel : HomeViewModel
    var namespace : Namespace.ID
    @Binding var showWeightDetailView : Bool
    
    var body: some View {
        VStack {
            WeightView(weightGoal: $viewModel.weightGoal, isWeightDetailView: $showWeightDetailView)
                .matchedGeometryEffect(id: "weight_view", in: namespace)
                .frame(maxWidth: .infinity, maxHeight: .infinity)                
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("weight_detail_view")
        }
    }
}
