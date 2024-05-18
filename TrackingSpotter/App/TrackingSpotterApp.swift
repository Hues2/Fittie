import SwiftUI

@main
struct TrackingSpotterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(.small ... .xxxLarge)
                .onAppear {
                    let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date
                    guard let installDate else {
                        // Install date hasn't been set yet
                        UserDefaults.standard.setValue(Date().startOfDay, forKey: Constants.UserDefaults.installDate)
                        return
                    }
                }
        }
    }
}
