import SwiftUI

struct UpdateWeightGoal: View {
    @Binding var weightGoal : Double?
    
    var body: some View {
        WeightInputView(title: "log_weight_view_title_update_weight_goal",
                        weight: $weightGoal,
                        saveAction: {
            saveAction()
        })
    }
}

private extension UpdateWeightGoal {
    func saveAction() {
        UserDefaults.standard.setValue(weightGoal, forKey: Constants.UserDefaults.weightGoal)
    }
}
