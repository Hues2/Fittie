import Foundation

struct CalendarData {
    static let calendar = Calendar.current
    static let year = calendar.component(.year, from: Date())
    
    static func months() -> [Month] {
        var months = [Month]()
        for monthIndex in 1...12 {
            let monthName = calendar.monthSymbols[monthIndex - 1]
            var days = [Date]()
            let dateComponents = DateComponents(year: year, month: monthIndex)
            if let date = calendar.date(from: dateComponents),
               let range = calendar.range(of: .day, in: .month, for: date) {
                days = range.compactMap { day -> Date? in
                    var components = dateComponents
                    components.day = day
                    return calendar.date(from: components)
                }
            }
            months.append(Month(name: monthName, days: days))
        }
        return months
    }
}
