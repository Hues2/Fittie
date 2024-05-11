import Foundation

extension Date {
    static var startOfDay : Date {
        Calendar.current.startOfDay(for: Date())
    }
}
