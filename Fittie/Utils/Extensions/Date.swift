import Foundation

extension Date {
    var startOfDay : Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let date1 = calendar.dateComponents([.year, .month, .day], from: self)
        let date2 = calendar.dateComponents([.year, .month, .day], from: otherDate)
        return date1 == date2
    }
    
    static func getDayFrom(date : Date, days : Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: date)
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: self)
    }
    
    func formattedWithOrdinalSuffix() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dayString = formatter.string(from: self)
        let day = Int(dayString) ?? 0
        
        var suffix = "th"
        switch day {
        case 1, 21, 31:
            suffix = "st"
        case 2, 22:
            suffix = "nd"
        case 3, 23:
            suffix = "rd"
        default:
            break
        }
        
        let dayWithSuffix = "\(dayString)\(suffix)"
        
        formatter.dateFormat = "MMMM yyyy"
        let monthYearString = formatter.string(from: self)
        
        return "\(dayWithSuffix) \(monthYearString)"
    }
}
