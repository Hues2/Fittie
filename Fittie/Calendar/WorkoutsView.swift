import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Query(sort: \WorkoutModel.date, animation: .smooth) private var loggedWorkouts : [WorkoutModel]
    @State private var selectedCalendarDate : CalendarDate?
    
    var body: some View {
        ZStack {
            BackgroundView()
            calendar
        }
        .navigationTitle("workouts_view_title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedCalendarDate) { calendarDate in
            AddWorkoutView(calendarDate: calendarDate)
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Constants.sheetCornerRadius)
        }
    }
}

private extension WorkoutsView {
    var calendar : some View {
        CustomCalendarView(getDayViewColor: { selectedDate in
            dayColor(selectedDate)
        }, dayTapped: { date in
            dayTapped(date)
        })
        .padding(.horizontal)
    }
}

// MARK: Day view colour -- Gets the background colour for the calendar day view
private extension WorkoutsView {
    private func dayColor(_ date: Date) -> Color {
        let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date ?? .now
        if loggedWorkouts.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            return Color.accentColor
        }
        
        // If the date is before the install date
        // If the date is in the future
        // Return light gray colour
//        print("Date --> \(date.formatted())")
//        print("installdate --> \(installDate.formatted())")
//        print("\n\n")
        if date < installDate { return .clear }
        
        if date > .now { return  .gray.opacity(0.2) }
//        if (date < installDate) || (date > .now) { return .gray.opacity(0.2) }
        
        // If the date is between now and the install date and there hasn't been a workout logged on that date
        // return the secondary accent colour
        return Color.secondaryAccent
    }
}

// MARK: Day tapped -- Pass in CalendarDate to LogWorkoutView
private extension WorkoutsView {
    func dayTapped(_ date : Date) {
        let selectedDateWorkout = loggedWorkouts
            .first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        self.selectedCalendarDate = CalendarDate(date: date, workout: selectedDateWorkout)
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
