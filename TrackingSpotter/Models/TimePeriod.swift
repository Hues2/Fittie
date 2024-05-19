import Foundation
import SwiftUI

enum TimePeriod: CaseIterable, Identifiable {
    case week
    case month
    
    var title : LocalizedStringKey {
        switch self {
        case .week:
            return "time_period_week"
        case .month:
            return "time_period_month"
        }
    }
    
    var numberOfDays : Int {
        switch self {
        case .week:
            return 7
        case .month:
            return 31
        }
    }
    
    var id : String { UUID().uuidString }
}
