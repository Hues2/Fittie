import Foundation
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
    
    static func disableScroll(_ shouldDisable : Bool) {
        UIScrollView.appearance().isScrollEnabled = shouldDisable
    }
}
