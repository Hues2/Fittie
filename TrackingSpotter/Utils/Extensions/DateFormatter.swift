import Foundation

extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Mon, Tue, Wed, etc.
        return formatter
    }()
}
