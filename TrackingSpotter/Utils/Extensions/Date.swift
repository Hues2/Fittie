import Foundation

extension Date {
    static var startOfDay : Date {
        Calendar.current.startOfDay(for: Date())
    }

    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: self)
    }
}
