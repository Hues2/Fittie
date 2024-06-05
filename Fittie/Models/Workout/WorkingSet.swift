import Foundation
import SwiftData

@Model
class WorkingSetModel {
    var kg : Double
    var reps : Int
    var exercise : ExerciseModel?
    
    init(kg: Double, reps: Int) {
        self.kg = kg
        self.reps = reps
    }
}


struct WorkingSet : Identifiable {
    let id : String = UUID().uuidString
    var kg : Double
    var reps : Int
}
