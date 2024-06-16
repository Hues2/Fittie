import SwiftUI

struct CalendarDayStyle {
    var strokeColor : Color = .clear
    var foregroundColor : Color = .primary
}


struct DayView : View {
    let day : Date
    let dayStyle: (Date) -> CalendarDayStyle
    let action : () -> Void
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: day))")
            .foregroundStyle(dayStyle(day).foregroundColor)
            .lineLimit(1)
            .frame(minWidth: 40, minHeight: 40)
            .background {
                Circle()
                    .stroke(dayStyle(day).strokeColor, lineWidth: 2.5)
            }
            .onTapGesture {
                action()                
            }
    }
}
