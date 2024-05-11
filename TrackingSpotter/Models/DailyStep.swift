import Foundation

struct DailyStep : Identifiable {
    let id = UUID()
    let date : Date
    let steps : Int
}
