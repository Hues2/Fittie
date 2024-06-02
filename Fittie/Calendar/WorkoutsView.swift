import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Workout.date, animation: .smooth) private var loggedWorkouts : [Workout]
    @State private var selectedCalendarDate : CalendarDate?
    
    var body: some View {
        ZStack {
            BackgroundView()
            calendar
        }
        .navigationTitle("workouts_view_title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedCalendarDate) { calendarDate in
            LogWorkoutView(calendarDate: calendarDate) { workout in
                saveWorkout(workout)
            }
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
        if loggedWorkouts.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
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
        self.selectedCalendarDate = CalendarDate(date: date, workout: selectedDateWorkout)
    }
}

// MARK: Save Workout
private extension WorkoutsView {
    func saveWorkout(_ workout : Workout) {
        // Save workout to context
        context.insert(workout)
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
