import SwiftUI

struct MonthlyCalendarView: View {
    @StateObject var calendarModel = CalendarModel()
    @State var monthId: MonthModel.ID?
    @State var showMonthLabel: Bool = false
    @State var viewInitialized: Bool = false
    

    var body: some View {
       
        VStack(
            alignment: .center,
            spacing: 0
            
        ) {
            // header
            VStack (
                alignment: .center,
                spacing: 20
            ) {
                // year label
                let displayMonthModel = calendarModel.monthModelFromId(monthId)
                Text(verbatim: "\(displayMonthModel.firstDayOfMonth.year())")
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .font(.system(size: 20))

                
                // weekday label
                HStackWithPadding(
                    leadingPadding: 10,
                    trailingPadding: 10
                ) {
                    let weekdaySymbols = Utility.weekdaySymbols()
                    ForEach(0..<weekdaySymbols.count, id: \.self) { i in
                        let symbol = weekdaySymbols[i]
                        Text(symbol)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 16))
                            .padding(.all, 5)
                            .foregroundStyle((i == 0 || i == 6) ? Color.red : Color.black)
                    }
                    
                }

            }
            .frame(height: 80, alignment: .top)
            .padding(.bottom, 5)
            .background(Color(UIColor.systemGray5))
            .overlay(Rectangle()
                .frame(height: 1, alignment: .bottom)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor.lightGray)), alignment: .bottom)

            // monthly calendar stack
            ZStack(
                alignment: .top
            ) {
                // month label
                if (showMonthLabel) {
                    let displayMonthModel = calendarModel.monthModelFromId(monthId)
                    
                    Text(displayMonthModel.firstDayOfMonth.yearMonthString())
                        .font(.system(size: 20))
                        .fontWeight(Font.Weight.bold)
                        .foregroundStyle(Color.black)
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .transition(.opacity)
                        .padding(.vertical, 5)
                        .background(Color.white)
                        .zIndex(2.0)
                }
                
                // scrollable monthly view
                ScrollView {
                    LazyVStack {
                        ForEach(calendarModel.monthList) { monthModel in
                            MonthView(monthModel: monthModel)
                                .onAppear {
                                    if monthModel == calendarModel.monthList.last{
                                        print("last visible row")
                                        Task {
                                            await calendarModel.addMonthAfter(5)
                                        }
                                    } else if monthModel ==  calendarModel.monthList.first {
                                        print("first visible row")
                                        Task {
                                            await calendarModel.addMonthBefore(5)
                                        }
                                    }
                                }
                        }
                    }
                    .scrollTargetLayout()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollPosition(id: $monthId)
                .padding(.vertical, 10)
                .onAppear{ monthId = calendarModel.idForCurrentMonth() }
                .scrollIndicators(.hidden)
                .onChange(of: monthId, initial: false) {
                    if ( !viewInitialized ) {
                        viewInitialized = true
                        return
                    }
                    showMonthLabel = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.smooth) {
                            showMonthLabel = false
                        }
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            
            // footer
            HStack {
                Button("TODAY") {
                    withAnimation(.default) {
                        monthId = calendarModel.idForCurrentMonth()
                    }
                }
                .foregroundStyle(Color.red)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray5))
            .overlay(Rectangle()
                .frame(height: 1, alignment: .top)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(UIColor.lightGray)), alignment: .top)
        }
    }
}

struct HStackWithPadding<Content>: View where Content: View  {

    var leadingPadding: CGFloat?
    var trailingPadding: CGFloat?

    @ViewBuilder var content: Content
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
                .frame(width: leadingPadding ?? 0, height: 10, alignment: .center)
            
            content
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()
                .frame(width: trailingPadding ?? 0, height: 10, alignment: .center)

        }
        
    }
}

class CalendarModel: ObservableObject {
    @Published var monthList: [MonthModel]
    
    init() {
        let today = Date()
        let firstDayOfCurrentMonth = today.firstDayOfMonth()
        var firstDayOfMonth = firstDayOfCurrentMonth.minusMonth(5)
        
        var monthList: [MonthModel] = [MonthModel(firstDayOfMonth)]

        for _ in 0..<11 {
            firstDayOfMonth = firstDayOfMonth.plusMonth()
            monthList.append(MonthModel(firstDayOfMonth))
        }
        
        self.monthList = monthList
    }
    
    func idForCurrentMonth() ->  UUID {
        let today = Date()
        let firstDayOfCurrentMonth = today.firstDayOfMonth()

        let currentMonth = monthList.filter {$0.firstDayOfMonth == firstDayOfCurrentMonth}
        if (currentMonth.isEmpty) {
            return UUID()
        } else {
            return currentMonth[0].id
        }
    }
    
    func monthModelFromId(_ id: UUID?) -> MonthModel {
        if id == nil {
            return MonthModel(Date().firstDayOfMonth())
        }
        return monthList.first(where: {$0.id == id }) ?? MonthModel(Date().firstDayOfMonth())
    }
    
    
    func addMonthAfter(_ count: Int) async {
        sleep(1)

        var firstDayOfLastMonth = monthList.last?.firstDayOfMonth ?? Date().firstDayOfMonth()
        for _ in 0..<count {
            firstDayOfLastMonth = firstDayOfLastMonth.plusMonth()
            let monthModel = MonthModel(firstDayOfLastMonth)
            DispatchQueue.main.async {
                self.monthList.append(monthModel)
            }
        }

    }
    
    func addMonthBefore(_ count: Int) async {
        sleep(1)
        var firstDayOfFirstMonth = monthList.first?.firstDayOfMonth ?? Date().firstDayOfMonth()
        for _ in 0..<count {
            firstDayOfFirstMonth = firstDayOfFirstMonth.minusMonth()
            let monthModel = MonthModel(firstDayOfFirstMonth)
            DispatchQueue.main.async {
                self.monthList.insert(monthModel, at: 0)
            }
        }

    }
}

class MonthModel: Identifiable, Equatable {
    var id = UUID()
    
    var firstDayOfMonth: Date
    var dayModelList: Array<DayModel>
    
    init(_ firstDayOfMonth: Date) {
        let days = firstDayOfMonth.daysInMonth()
        
        // starting empty spaces
        let startingSpaces = firstDayOfMonth.weekDay()
        var dayModelList = Array(repeating: DayModel(nil), count: startingSpaces)

        // actual day in month
        var date = firstDayOfMonth
        dayModelList.append(DayModel(date))
        for _ in 1..<days {
            date = date.plusDate()
            dayModelList.append(DayModel(date))
        }
        
        // trailing empty spaces
        let monthRowCount = Int(ceil((Double(days + startingSpaces)/7)))
        let trailingSpaces = Array(repeating: DayModel(nil), count: monthRowCount * 7 - days - startingSpaces)
        dayModelList.append(contentsOf: trailingSpaces)
        
        self.firstDayOfMonth = firstDayOfMonth
        self.dayModelList = dayModelList
    }
    
    
    func numberOfRows() -> Int {
        let days = firstDayOfMonth.daysInMonth()
        let startingSpaces = firstDayOfMonth.weekDay()
        let monthRowCount = Int(ceil((Double(days + startingSpaces)/7)))
        return monthRowCount
    }
    
    
    static func == (lhs: MonthModel, rhs: MonthModel) -> Bool{
        return lhs.id == rhs.id
    }
}

struct DayView: View {
    var dayModel: DayModel

    var body: some View {
        VStack(
            alignment: .center,
            spacing: 8
        ) {
            if let date = dayModel.date {
                let isToday =  date.isToday()
                let isWeekend = date.isWeekend()
                let hasEvent = dayModel.hasEvent
                let foregroundColor = isToday ? Color.white : isWeekend ? Color.red : Color.black

                Text("\(date.day())")
                    .padding(8)
                    .font(.system(size: 18))
                    .fontWeight(
                        isToday ? Font.Weight.bold : Font.Weight.regular
                    )
                    .foregroundStyle(foregroundColor)
                    .background(Circle()
                        .fill( isToday ? Color.red : Color.white )
                        .frame(width: 35, height: 35, alignment: .center)
                    )
                if (hasEvent) {
                    Circle()
                        .fill(Color(UIColor.gray))
                        .frame(width: 8, height: 8)
                }
            }
            
                
        }
        .frame(width: 40, height: 55, alignment: .top)
        .padding(.vertical, 5)
    }
}

struct DayModel: Identifiable {
    var id: UUID = UUID()
    
    var date: Date?
    var hasEvent: Bool
    
    init(_ date: Date?) {
        self.date = date
        self.hasEvent = date?.day().isMultiple(of: 5) ?? false
    }
    
}

struct MonthView: View {
    var monthModel: MonthModel
    @State var leadingPadding: CGFloat?

    var body: some View {
        var coordinateSpaceName: String = "monthViewVStack"
        let firstDayOfMonth = monthModel.firstDayOfMonth
        let startingSpaces = firstDayOfMonth.weekDay()

        let isCurrentMonth = firstDayOfMonth.isCurrentMonth()

        VStack(
            alignment: .center,
            spacing: 10
        ) {
            
            // month label
            Text("\(firstDayOfMonth.localizedMonthString())")
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20))
                .fontWeight(
                    Font.Weight.bold
                )
                .foregroundStyle(
                    isCurrentMonth ? Color.red : Color.black
                )
                .padding(.leading, 5 + 5)
                .foregroundStyle(Color.red)

            // days
            ForEach(0..<monthModel.numberOfRows(), id: \.self) { row in
                HStack(
                    alignment: .center
                ) {
                    Spacer()
                        .frame(width: 10, height: 10, alignment: .center)
                
                    ForEach(0..<7) { column in
                        let dayIndex = column + (row * 7)
                        let dayModel = monthModel.dayModelList[dayIndex]
                        DayView(dayModel: dayModel)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .overlay(GeometryReader{ geometry -> Color in
                                if (dayIndex == startingSpaces) {
                                    DispatchQueue.main.async {
                                        leadingPadding  = geometry.frame(in: .named(coordinateSpaceName)).minX
                                    }
                                }
                                
                                return Color.clear
                            })
                    }
                
                    Spacer()
                        .frame(width: 10, height: 10, alignment: .center)
                
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .coordinateSpace(name: coordinateSpaceName)
    }
}

extension Date {
    
    // get day part of a date (Int)
    func day() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return Int(dateFormatter.string(from: self))!
    }
    
    
    // get month part of a date (Int)
    func month() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return Int(dateFormatter.string(from: self))!
    }
    
    
    // get year part of a date (Int)
    func year() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: self))!
    }
    
    
    // get localized month string of a date (String)
    func localizedMonthString() -> String {
        let calendar = Calendar.current
        return calendar.shortStandaloneMonthSymbols[self.month() - 1]
    }
    
    
    // get localized Year Month string of a date (String)
    func yearMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM"
        return dateFormatter.string(from: self)
    }
    
    
    // get weekday of a date (Int)
    // 0: Sunday
    func weekDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday! - 1
    }

    
    // get the number of days in the month of a date (Int)
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    
    // get the date of the first day in the month of a date (Date)
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let date = Utility.dateFromString(month: self.month(), year: self.year(), day: 1)
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    
    // add days to current date (Date)
    func plusDate(_ count: Int = 1) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: count, to: self)!
    }
    
    
    // minus days from current date (Date)
    func minusDate(_ count: Int = 1) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -count, to: self)!
    }
    
    
    // add months from current date (Date)
    func plusMonth(_ count: Int = 1) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: count, to: self)!
    }
    
    
    // minus months from current date (Date)
    func minusMonth(_ count: Int = 1) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -count, to: self)!
    }

    
    // is the date today (Bool)
    func isToday() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let todayDateString = dateFormatter.string(from: Date())
        let dateToCompareString = dateFormatter.string(from: self)
        return (todayDateString == dateToCompareString)
    }
    
    
    // is the date a weekend (Bool)
    func isWeekend() -> Bool {
        let weekday = self.weekDay()
        return ((weekday == 0 ) || (weekday == 6))
    }
    
    
    // is the date in the same month as today (Bool)
    func isCurrentMonth() -> Bool {
        let today = Date()
        return (today.year() == self.year()) && (today.month() == self.month())
    }
    
}

class Utility {
    
    // A list of very-shortly-named weekdays in this calendar, localized to the Calendar’s locale.
    // ex: for English in the Gregorian calendar, returns ["S", "M", "T", "W", "T", "F", "S"]
    static func weekdaySymbols() -> [String] {
        let calendar = Calendar.current
        return calendar.veryShortStandaloneWeekdaySymbols
    }
    
    
    static func dateFromString(month: Int, year: Int, day: Int) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.date(from: "\(addPadding(year, 4))/\(addPadding(month, 2))/\(addPadding(day, 2))")!
    }
    
    
    private static func addPadding(_ int: Int, _ targetDigit: Int ) -> String {
        return String(format: "%0\(targetDigit)d", int)
    }
}


#Preview {
    MonthlyCalendarView()
}
