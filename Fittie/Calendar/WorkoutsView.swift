import SwiftUI
import SwiftData

struct WorkoutsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Query(sort: \WorkoutModel.date, animation: .smooth) private var loggedWorkouts : [WorkoutModel]
    @State private var selectedCalendarDate : CalendarDate?
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            content
        }
        .toolbar(.hidden)
        .sheet(item: $selectedCalendarDate) { calendarDate in
            AddWorkoutView(calendarDate: calendarDate)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(Constants.sheetCornerRadius)
        }
    }
}

// MARK: Content
private extension WorkoutsView {
    var content : some View {
        calendar
            .overlay(alignment: .top) {
                legend
            }
    }
}

// MARK: Calendar legend
private extension WorkoutsView {
    var legend : some View {
        HStack {
            legendItem(.thirdAccent, title: "workouts_legend_today")
            legendItem(.accent, title: "workouts_legend_logged")
            legendItem(.secondaryAccent, title: "workouts_legend_not_logged")
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .frame(height: Constants.calendarLegendHeight)
        .padding(.top, safeAreaInsets.top)
        .padding(8)
        .background(Material.ultraThinMaterial)
        .cornerRadius(Constants.sheetCornerRadius, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea()
    }
    
    func legendItem(_ color : Color, title : LocalizedStringKey) -> some View {
        HStack {
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: 20, height: 20)
            Text(title)
                .font(.subheadline)
                .fontWeight(.light)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: Calendar
private extension WorkoutsView {
    var calendar : some View {
        ScrollView {
            CustomCalendarView(getDayViewColor: { selectedDate in
                dayColor(selectedDate)
            }, dayTapped: { date in
                dayTapped(date)
            })
            .padding(.horizontal)
        }
        .contentMargins(.top, Constants.calendarLegendHeight + 32, for: .scrollContent)
        .scrollIndicators(.hidden)
    }
}

// MARK: Day view colour -- Gets the background colour for the calendar day view
private extension WorkoutsView {
    private func dayColor(_ date: Date) -> Color {
        let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date ?? .now
        if loggedWorkouts.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            return Color.accentColor
        }
        
        // If it's todays date, and no workout has been completed, then send this colour
        if date.isSameDay(as: .now) { return Color.thirdAccent }
        
        // If the date is before the install date, return .clear
        if date < installDate { return .clear }
        // If the date is in the future, return gray colour
        if date > .now { return  .gray.opacity(0.2) }
        
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

