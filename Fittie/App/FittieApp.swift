import SwiftUI
import SwiftData

@main
struct FittieApp: App {
    var container : ModelContainer {
        let schema = Schema([Weight.self])
        do {
            let container = try ModelContainer(for: schema, configurations: [])
            return container
        } catch {
            fatalError("Unable to create model container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(Constants.dynamicTypeSizeRange)
                .onAppear {
                    setInstallDate()
                }
                .modelContainer(container)
        }
    }
    
    private func setInstallDate() {
        let installDate = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date
        guard installDate != nil else {
            // Install date hasn't been set yet
            UserDefaults.standard.setValue(Date().startOfDay, forKey: Constants.UserDefaults.installDate)
            return
        }
    }
}
