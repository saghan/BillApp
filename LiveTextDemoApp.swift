import SwiftUI

@main
struct LiveTextDemoApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                               persistenceController.container.viewContext) }
    }
}
