import Foundation

struct CalendarData {
    static let calendar = Calendar.current
    static let year = calendar.component(.year, from: Date())
    
    static func months() -> [Month] {
        var months = [Month]()
        // Months should start from the install date
        let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date ?? .now
        let currentDate = Date()
        // Calendar will show up until the current month + 1
        guard let endDate = calendar.date(byAdding: .month, value: Constants.numberOfCalendarFutureMonths, to: currentDate) else {
            return months
        }
        
        var currentMonth = installDate
        while currentMonth <= endDate {
            if let month = createMonth(for: currentMonth, using: calendar) {
                months.append(month)
            }
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                currentMonth = nextMonth
            } else {
                break
            }
        }
        
        return months
    }
    
    private static func createMonth(for date: Date, using calendar: Calendar) -> Month? {
        let monthName = calendar.monthSymbols[calendar.component(.month, from: date) - 1]
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let monthStartDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return nil
        }
        
        var days = [Date]()
        for day in monthRange {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStartDate) {
                days.append(dayDate)
            }
        }
        
        return Month(name: monthName, days: days)
    }
}
