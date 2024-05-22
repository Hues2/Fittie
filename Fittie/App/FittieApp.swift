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
                .modelContainer(container)
        }
    }
}
