import SwiftUI

struct CustomCalendarView: View {
    let getDayViewStyle : (Date) -> CalendarDayStyle
    let dayTapped : (Date) -> Void
    
    var body: some View {
        content
    }
}

// MARK: Content
private extension CustomCalendarView {
    var content : some View {
        LazyVStack(spacing: 20) {
            ForEach(Array(CalendarData.months().enumerated()), id:\.offset) { item in
                MonthView(month: item.element,
                          dayTapped: dayTapped,
                          dayStyle: getDayViewStyle)
                .scrollTransition { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.7)
                        .scaleEffect(phase.isIdentity ? 1 : 0.85)
                        .blur(radius: phase.isIdentity ? 0 : 2)
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
    NavigationStack {
        WorkoutsView()
    }
}
