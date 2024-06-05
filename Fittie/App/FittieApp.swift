import SwiftUI
import SwiftData

@main
struct FittieApp: App {
    var container : ModelContainer {
        let schema = Schema([Weight.self, WorkoutModel.self, ExerciseModel.self, WorkingSetModel.self])
        do {
            let container = try ModelContainer(for: schema, configurations: [])
            return container
        } catch {
            fatalError("Unable to create model container")
        }
    }
    
    var context : ModelContext {
        let context = ModelContext(container)
        context.autosaveEnabled = true
        return context
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(Constants.dynamicTypeSizeRange)
                .modelContext(context)
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
