import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    
    var numberOfDaysAgo : Int {
        switch self {
        case .week:
            return 7
        case .month:
            return 31
        }
    }
    
    var id: String { self.rawValue }
}
