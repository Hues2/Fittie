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
}
