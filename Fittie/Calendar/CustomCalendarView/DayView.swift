import SwiftUI

struct CalendarDayStyle {
    var strokeColor : Color = .clear
    var foregroundColor : Color = .primary
    var isTodaysDate : Bool = false
}


struct DayView : View {
    let day : Date
    let dayStyle: (Date) -> CalendarDayStyle
    let action : () -> Void
    
    var body: some View {
        VStack(spacing: 1) {
            Color.clear
                .frame(width: 5, height: 1)
            
            Text("\(Calendar.current.component(.day, from: day))")
            
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(dayStyle(day).isTodaysDate ? Color.primary : Color.clear)
                .frame(width: 12, height: 1)
        }
        .lineLimit(1)
        .frame(minWidth: 42, minHeight: 42)
        .background {
            Circle()
                .stroke(dayStyle(day).strokeColor, lineWidth: 1)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    DayView(day: .now) { day in
        return CalendarDayStyle(strokeColor: .secondaryAccent, isTodaysDate: true)
    } action: {
        
    }
}

#Preview {
    NavigationStack {
        WorkoutsView(viewModel: .init())
    }
}

