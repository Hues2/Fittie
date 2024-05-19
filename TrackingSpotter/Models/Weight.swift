import Foundation
import SwiftData

@Model
class Weight {
    let date : Date
    let kg : Double
    
    init(date: Date, kg: Double) {
        self.date = date
        self.kg = kg
    }
}
