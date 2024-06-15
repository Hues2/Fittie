import SwiftUI

struct CustomCalendarView: View {
    let getDayViewColor : (Date) -> Color
    let dayTapped : (Date) -> Void
    
    var body: some View {
        content
    }
}

// MARK: Content
private extension CustomCalendarView {
    var content : some View {
        ScrollView {
            LazyVStack {
                ForEach(CalendarData.months()) { month in
                    MonthView(month: month,
                              dayTapped: dayTapped,
                              dayColor: getDayViewColor)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: Day Tapped Functionality
private extension CustomCalendarView {
    private func dayTapped(_ date: Date) {
        self.dayTapped(date)
    }
}
