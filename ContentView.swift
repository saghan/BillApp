//
//  ContentView.swift
//  LiveTextDemo
//
//  Created by Simon Ng on 14/6/2022.
//

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
    @State private var expense: Float = 0
    @State private var ResetIncome: Bool = false
    @State private var showingSheet = false
    @State private var touchCountContentView: Int = 0
    @State private var save: Bool = false
    @State private var storeName: String = ""
    @State private var total: String = ""

    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(entity: Entity.entity(), sortDescriptors: [])
        private var products: FetchedResults<Entity>
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }


    init(){
//        print(UserDefaults.standard.bool(forKey: "isIncomeSet"))
        UserDefaults.standard.set(false, forKey: "isIncomeSet")

    
    }
    
    var body: some View {
        //        let _x = Self._printChanges()
        NavigationView {
            VStack{
                Button("Add expense (Receipt)", systemImage: "plus"){
                    showingSheet.toggle()
                }.labelStyle(.iconOnly).imageScale(.large)
                    .sheet(isPresented: $showingSheet) {
                        HStack{
                            Button("Save Receipt"){
                                save=true
                                
                            }.buttonStyle(.bordered)
                            Button("Close"){
                                showingSheet = false
                                
                            }.buttonStyle(.bordered)
                            
//                            Button("Delete all receipts"){
//                                deleteAll()
//                            }.buttonStyle(.bordered)
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
                            Text("Total: ")
                            TextField("",text: $total).textFieldStyle(.roundedBorder)
                        }
                        
                            DataScanner(startScanning: $startScanning, scanText: $scanText, storeName: $storeName, total: $total, touchCount: $touchCountContentView, save: $save)
                                .frame(height: 400)
                    }.task {
                        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                            startScanning.toggle()
                        }
                    }
                VStack {
                    ForEach(products) { product in
                        ReceiptView(product: product)
                    }
                }
//                NavigationLink(destination: HolaView()) {
//                    Text("See Monthly Expense")
//                }

            } //vstack. for some reason Navigation View should have a VStack
    } //NV
    } //body
} //CV

struct HolaView: View {
    var body: some View {
        Text("Hola, como estas?")
    }
}
   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
