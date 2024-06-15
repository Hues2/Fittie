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
        LazyVStack {
            ForEach(Array(CalendarData.months().enumerated()), id:\.offset) { item in
                MonthView(month: item.element,
                          dayTapped: dayTapped,
                          dayColor: getDayViewColor)
            }
        }                
    }
}

// MARK: Day Tapped Functionality
private extension CustomCalendarView {
    private func dayTapped(_ date: Date) {
        self.dayTapped(date)
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
