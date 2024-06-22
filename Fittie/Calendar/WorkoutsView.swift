import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @EnvironmentObject private var router : Router
    @ObservedObject var viewModel : WorkoutsViewModel
    @Query(sort: \WorkoutModel.date, animation: .smooth) private var loggedWorkouts : [WorkoutModel]
    @State private var selectedCalendarDate : CalendarDate?
    @State private var offset: CGFloat = .zero        
    
    var body: some View {
        ZStack {
            BackgroundView()
            content
        }
        .toolbar(.hidden)        
    }
}

// MARK: Content
private extension WorkoutsView {
    var content : some View {
        calendar
    }
}

// MARK: Calendar
private extension WorkoutsView {
    var calendar : some View {        
        CustomCalendarView(getDayViewStyle: { selectedDate in
            dayStyle(selectedDate)
        }, dayTapped: { date in
            dayTapped(date)
        })
        .padding(.horizontal)
        .padding(.bottom, 16)            
    }
}

// MARK: Day View Style
private extension WorkoutsView {
    private func dayStyle(_ date: Date) -> CalendarDayStyle {
        var calendarDayStyle = CalendarDayStyle()
        calendarDayStyle.isTodaysDate = date.startOfDay.isSameDay(as: .now.startOfDay)
        
        let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date ?? .now
        if loggedWorkouts.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            calendarDayStyle.strokeColor = Color.accentColor
        } else if date < installDate.startOfDay {
            // If the date is before the install date, stroke should be .clear
            calendarDayStyle.strokeColor = .clear
        } else if date > .now.startOfDay {
            // If the date is in the future, stroke should be .gray
            calendarDayStyle.strokeColor = .gray.opacity(0.2)
        } else {
            // If the date is between now and the install date and there hasn't been a workout logged on that date
            // stroke should be secondary accent colour
            calendarDayStyle.strokeColor = .secondaryAccent
        }
        
        return calendarDayStyle
    }
}

// MARK: Day tapped -- Pass in CalendarDate to LogWorkoutView
private extension WorkoutsView {
    func dayTapped(_ date : Date) {
        let selectedDateWorkout = loggedWorkouts
            .first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        self.viewModel.setSelectedCalendarDate(CalendarDate(date: date, workout: selectedDateWorkout))
    }
}

#Preview {
    NavigationStack {
        WorkoutsView(viewModel: WorkoutsViewModel())
    }
}

