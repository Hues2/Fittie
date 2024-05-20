import Foundation

struct DailyStep : Identifiable, Equatable {
    let id = UUID()
    let date : Date
    let steps : Int
    var animate : Bool = false
}
