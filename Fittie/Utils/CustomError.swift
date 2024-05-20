import Foundation

enum CustomError : Error {
    // HealthKit
    case healhKitAuthError(String)
}

extension CustomError {
    var descritpion : String {
        switch self {
        case .healhKitAuthError(let error):
            return error
        }
    }
}
