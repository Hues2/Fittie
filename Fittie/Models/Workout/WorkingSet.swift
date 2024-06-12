import Foundation
import SwiftData

@Model
class WorkingSetModel {
    var number : Int
    var kg : Double
    var reps : Int
    var exercise : ExerciseModel?
    
    init(number : Int, kg: Double, reps: Int) {
        self.number = number
        self.kg = kg
        self.reps = reps
    }
    
    func getWorkingSet() -> WorkingSet {
        return WorkingSet(number: self.number, kg: self.kg, reps: self.reps)
    }
}


struct WorkingSet : Identifiable {
    let id : String = UUID().uuidString
    var number : Int
    var kg : Double
    var reps : Int
}
