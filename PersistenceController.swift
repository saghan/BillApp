import CoreData
 
struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
 
    init() {
        container = NSPersistentContainer(name: "PhotoData") //name of the data file created
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Container load failed: \(error)")
            }
        }
    }
}
