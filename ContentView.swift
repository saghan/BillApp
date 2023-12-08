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

    @Environment(\.managedObjectContext) private var viewContext
        @FetchRequest(entity: Entity.entity(), sortDescriptors: [])
        private var products: FetchedResults<Entity>

    init(){
//        print(UserDefaults.standard.bool(forKey: "isIncomeSet"))
        UserDefaults.standard.set(false, forKey: "isIncomeSet")
    
    }
    
    var body: some View {
        //        let _x = Self._printChanges()
        NavigationView {
            VStack{
                if(UserDefaults.standard.bool(forKey: "isIncomeSet")){
                    VStack{
                        
                        Text("Income is: $"+income)
                        Button("Reset income") {
                            ResetIncome=true
                        }
                        if ResetIncome {
                            Text("Enter Income")
                            TextField("", text: $income)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                            Button("Set"){
                                UserDefaults.standard.set(true, forKey: "isIncomeSet")
                                UserDefaults.standard.set(income, forKey: "Income")
                                ResetIncome=false
                            }.buttonStyle(.bordered)
                        }
                    } //ResetIncome
                } //isIncomeSet
                else{
                    VStack {
                        HStack{
                            Text("Enter Income")
                            TextField("", text: $income)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                            Button("Set"){
                                //                        print("income set from 55")
                                UserDefaults.standard.set(true, forKey: "isIncomeSet")
                                UserDefaults.standard.set(income, forKey: "Income")
                                
                            }.buttonStyle(.bordered)
                        } //hstack
                        HStack{
                            Text("Expense this month:")
                            Text(String(expense))
                            
                        }
                        Text(scanText)
                        
                    } //vstack
                    .onAppear{
                    }
                } //else
                Button("Add expense (Receipt)", systemImage: "plus"){
                    showingSheet.toggle()
                }.labelStyle(.iconOnly).imageScale(.large)
                    .sheet(isPresented: $showingSheet) {
                        HStack{
                            Button("Save Receipt"){
                                save=true
                                
                            }.buttonStyle(.bordered)
                            Button("Close"){
                                
                            }.buttonStyle(.bordered)
                        }
                        if(touchCountContentView==0){
                            Text("Select name of Store")
                        }
                        if(touchCountContentView==1){
                            Text("Select total")
                        }
                            DataScanner(startScanning: $startScanning, scanText: $scanText, touchCount: $touchCountContentView, save: $save)
                                .frame(height: 400)
                    }.task {
                        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                            startScanning.toggle()
                        }
                    }
                List {
                                    ForEach(products) { product in
                                        HStack {
                                            if let unwrapped = product.billImage {
                                                let x = UIImage(data: unwrapped)
                                                if let Ux = x {
                                                    Image(uiImage: Ux)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                NavigationLink(destination: HolaView()) {
                    Text("View Receipts")
                }

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
