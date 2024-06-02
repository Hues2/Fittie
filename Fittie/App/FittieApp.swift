import SwiftUI
import SwiftData

@main
struct FittieApp: App {
    var container : ModelContainer {
        let schema = Schema([Weight.self, Workout.self, Exercise.self, WorkingSet.self])
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
                .modelContainer(container)
                .onAppear {
                    setInstallDate()
                }
        }
    }
    
    private func setInstallDate() {
        let installDate : Date? = UserDefaults.standard.value(forKey: Constants.UserDefaults.installDate) as? Date
        guard installDate == nil else { return }
        UserDefaults.standard.setValue(Date(), forKey: Constants.UserDefaults.installDate)
    }
}
