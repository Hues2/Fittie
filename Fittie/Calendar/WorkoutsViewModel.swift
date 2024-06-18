import SwiftUI

class WorkoutsViewModel : ObservableObject {
    @Published var selectedCalendarDate : CalendarDate?
    
    func setSelectedCalendarDate(_ calendarDate : CalendarDate) {
        self.selectedCalendarDate = calendarDate
    }
}
