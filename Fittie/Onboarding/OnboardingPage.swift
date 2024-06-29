import SwiftUI

enum OnboardingPage : Int, Identifiable, CaseIterable {
    case setStepGoal = 0
    case setWeightGoal = 1
    case getHealthKitPermission = 2
    case allSet = 3
    
    var id : Int { self.rawValue }
    
    var buttonTitle : LocalizedStringKey {
        switch self {
        case .setStepGoal:
            return "onboarding_next_button_title"
        case .setWeightGoal:
            return "onboarding_next_button_title"
        case .getHealthKitPermission:
            return "onboarding_set_permissions_button_title"
        case .allSet:
            return "onboarding_finish_button_title"
        }
    }
}
