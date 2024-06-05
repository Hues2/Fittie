import Foundation
import SwiftData

@Model
class Workout {
    let id : String = UUID().uuidString
    var date : Date
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout)
    var exercises = [Exercise]()
    
    init(date: Date) {
        self.date = date
    }
}
