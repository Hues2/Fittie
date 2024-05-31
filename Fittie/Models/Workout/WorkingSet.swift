import Foundation
import SwiftData

@Model
class WorkingSet {
    var kg : Double
    var reps : Int
    
    init(kg: Double, reps: Int) {
        self.kg = kg
        self.reps = reps
    }
}
