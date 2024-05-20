import Foundation
import SwiftData

@Model
class Weight {
    var date : Date
    var kg : Double
    
    init(date: Date, kg: Double) {
        self.date = date
        self.kg = kg
    }
}
