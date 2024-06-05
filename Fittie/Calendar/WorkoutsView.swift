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
        let selectedDateWorkout = loggedWorkouts
            .first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
            .map({ Workout(date: $0.date, exercises: $0.exercises
                .map({ Exercise(exerciseCategoryRawValue: $0.exerciseCategoryRawValue, exerciseName: $0.exerciseName, sets: $0.sets
                    .map({ WorkingSet(kg: $0.kg, reps: $0.reps) })) })) })
        self.selectedCalendarDate = CalendarDate(date: date, workout: selectedDateWorkout)
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
