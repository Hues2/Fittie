import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Workout.date, animation: .smooth) private var loggedWorkouts : [Workout]
    @State private var selectedCalendarDate : CalendarDate?
    @State private var selectedWorkout : Workout?
    
    var body: some View {
        ZStack {
            BackgroundView()
            calendar
        }
        .navigationTitle("workouts_view_title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedCalendarDate) { calendarDate in
            LogWorkoutView(calendarDate: calendarDate, workout: selectedWorkout) { workout in
                
            }
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
        if Calendar.current.isDateInToday(date) {
            return Color.accentColor
        } else {
            return Color.pink
        }
    }
}

// MARK: Day tapped -- Pass in CalendarDate to LogWorkoutView
private extension WorkoutsView {
    func dayTapped(_ date : Date) {
        let selectedDateWorkout = loggedWorkouts.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
        self.selectedWorkout = selectedDateWorkout
        self.selectedCalendarDate = CalendarDate(date: date)
    }
}

// MARK: Save Workout
private extension WorkoutsView {
    func saveWorkout(_ workout : Workout) {
        // Save workout to context
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
