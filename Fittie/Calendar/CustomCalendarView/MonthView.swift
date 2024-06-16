import SwiftUI

struct Month: Identifiable {
    let id = UUID()
    let name: String
    let days: [Date]
}

struct MonthView: View {
    let month: Month
    let dayTapped: (Date) -> Void
    let dayStyle: (Date) -> CalendarDayStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(month.name)
                .font(.title2)
                .fontWeight(.light)
                .foregroundStyle(.secondaryAccent)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(month.days, id: \.self) { day in
                    DayView(day: day, dayStyle: dayStyle) {
                        dayTapped(day)
                    }
                }
            }
            .padding(12)
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutsView()
    }
}
