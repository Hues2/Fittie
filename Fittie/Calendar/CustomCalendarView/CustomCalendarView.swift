import SwiftUI

struct CustomCalendarView: View {
    private let months = CalendarData.months()
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
                ForEach(months) { month in
                    MonthView(month: month,
                              dayTapped: dayTapped,
                              dayColor: getDayViewColor)
                }
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
    WorkoutsView()
}
