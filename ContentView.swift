import SwiftUI
import VisionKit
import CoreData
class GameSettings: ObservableObject {
    @Published var score = 0
}
struct ContentView: View {
    
    @State private var startScanning = false
    @State private var scanText = ""
    @State private var income: String = ""
    @State private var ResetIncome: Bool = false
    @State private var showingSheet = false
    @State private var isHelpPresented = false
    @State private var touchCountContentView: Int = 0
    @State private var save: Bool = false
    @State private var storeName: String = ""
    @State private var total: String = ""
    @State private var billDate: String = ""

    

    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(entity: Entity.entity(), sortDescriptors: [])
        private var products: FetchedResults<Entity>
    func delete(at offsets: IndexSet){
        for index in offsets {
               let product = products[index]
            viewContext.delete(product)
           }
        do {
            try viewContext.save()
        } catch {
            // handle the Core Data error
        }
    }
    var dateFormatter = DateFormatter()

    var body: some View {
        let _x = dateFormatter.dateFormat = "YY/MM/dd"

        NavigationView {
            VStack{
                HStack{
                    Button("Add photo of your receipt"){
                        showingSheet.toggle()
                    }.controlSize(.large)
                        .foregroundColor(.red).fontWeight(.heavy)
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showingSheet) {
                            HStack{
                                Button("Save Receipt"){
                                    save=true
                                }.buttonStyle(.bordered)
                                Button("Close"){
                                    showingSheet = false
                                    
                                }.buttonStyle(.bordered)
                            }
                            
                            if(touchCountContentView==0){
                                Text("Touch store name in photo").foregroundStyle(.red).font(.title)
                            }
                            if(touchCountContentView==1){
                                Text("Touch total in photo").foregroundStyle(.red).font(.title)
                            }
                            // editable fields for name and total
                            HStack {
                                Text("Store name: ")
                                TextField("",text: $storeName).textFieldStyle(.roundedBorder)
                            }
                            HStack {
                                Text("Date: ")
                                TextField(dateFormatter.string(from: Date.now),text: $billDate).textFieldStyle(.roundedBorder)
                            }
                            HStack {
                                Text("Total: ")
                                TextField("",text: $total).textFieldStyle(.roundedBorder)
                            }
                            
                            DataScanner(startScanning: $startScanning, scanText: $scanText, storeName: $storeName,total: $total, date: $billDate, touchCount: $touchCountContentView, save: $save)
                                .frame(height: 400)
                        }.task {
                            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                                startScanning.toggle()
                            }
                        } //showingsheet
                    Button{
                        isHelpPresented = true
                    }
                label: {
                    Image(systemName: "questionmark.circle")
                }.sheet(isPresented: $isHelpPresented){
                    Button("Close"){
                        isHelpPresented = false
                    }.buttonStyle(.bordered).labelsHidden()
                    Text("Take a photo of your receipt, like receipt from grocery store.").font(.title)
                    Text("This will save your receipt in case you need it to return a purchase.").foregroundColor(.green).font(.title)
                    Text("It is also used to track your monthly expense.").font(.title)
                    ScrollView{
                        Image("billimg").resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                } //Hstack button and help
                List {
                    ForEach(products) { product in
                        ReceiptView(product: product)
                    }.onDelete(perform: delete)
                }
                HStack{
                    NavigationLink(destination: MonthlyExpenseView()) {
                        Text("See Monthly Expense").foregroundStyle(.green).fontWeight(.heavy)
                    }.buttonStyle(.bordered)
                    Spacer()
                    Link("Feedback", destination: URL(string: "mailto:saghanapple@gmail.com")!)
                }
                

            } //vstack. for some reason Navigation View should have a VStack
    } //NV
    } //body
} //CV

   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
