import SwiftUI
import UIKit

class Utils {
    static func openUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
