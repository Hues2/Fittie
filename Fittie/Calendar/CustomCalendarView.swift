import SwiftUI

struct CustomCalendarView: View {
    let months = CalendarData.months()
    @State private var selectedDate: Date?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(months) { month in
                    MonthView(month: month,
                              dayTapped: dayTapped,
                              dayColor: dayColor)
                }
            }
        }
    }
    
    private func dayTapped(_ date: Date) {
        selectedDate = date
        print("Selected day: \(date)")
    }
    
    private func dayColor(_ date: Date) -> Color {
        if Calendar.current.isDateInToday(date) {
            return Color.accentColor
        } else {
            return Color.pink
        }
    }
}

struct Month: Identifiable {
    let id = UUID()
    let name: String
    let days: [Date]
}

struct CalendarData {
    static let calendar = Calendar.current
    static let year = calendar.component(.year, from: Date())
    
    static func months() -> [Month] {
        var months = [Month]()
        for monthIndex in 1...12 {
            let monthName = calendar.monthSymbols[monthIndex - 1]
            var days = [Date]()
            let dateComponents = DateComponents(year: year, month: monthIndex)
            if let date = calendar.date(from: dateComponents),
               let range = calendar.range(of: .day, in: .month, for: date) {
                days = range.compactMap { day -> Date? in
                    var components = dateComponents
                    components.day = day
                    return calendar.date(from: components)
                }
            }
            months.append(Month(name: monthName, days: days))
        }
        return months
    }
}

struct MonthView: View {
    let month: Month
    let dayTapped: (Date) -> Void
    let dayColor: (Date) -> Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(month.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(month.days, id: \.self) { day in
                    Text("\(Calendar.current.component(.day, from: day))")
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(dayColor(day)))
                        .onTapGesture {
                            dayTapped(day)
                        }
                }
            }
            .padding()
            .background(Constants.backgroundMaterial)
            .cornerRadius(Constants.cornerRadius, corners: .allCorners)
            .padding(.bottom, 20)
        }        
    }
}

#Preview {
    WorkoutsView()
}
