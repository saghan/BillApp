import SwiftUI

@main
struct BillScannerApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                               persistenceController.container.viewContext) }
    }
}
