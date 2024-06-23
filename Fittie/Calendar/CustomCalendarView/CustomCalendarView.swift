import SwiftUI

struct CustomCalendarView: View {
    private let calendarData = CalendarData.months()
    // This is used to scroll to the current month on appear
    private let currentMonthName = Calendar.current.monthSymbols[Calendar.current.component(.month, from: .now) - 1]
    @State private var hasScrolledToCurrentMonth : Bool = false
    let getDayViewStyle : (Date) -> CalendarDayStyle
    let dayTapped : (Date) -> Void
    
    var body: some View {
        content
    }
}

// MARK: Content
private extension CustomCalendarView {
    var content : some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(calendarData.enumerated()), id:\.offset) { item in
                        MonthView(month: item.element,
                                  dayTapped: dayTapped,
                                  dayStyle: getDayViewStyle)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.7)
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                .blur(radius: phase.isIdentity ? 0 : 2)
                        }
                        .id(item.element.name)
                    }
                }
                .padding()
            }
            .contentMargins(.top, 24, for: .scrollContent)
            .scrollIndicators(.hidden)
            .onAppear {
                guard !hasScrolledToCurrentMonth else { return }
                DispatchQueue.main.async {
                    proxy.scrollTo(currentMonthName, anchor: .top)                    
                }
                self.hasScrolledToCurrentMonth = true
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
        WorkoutsView(viewModel: .init())
    }
}
