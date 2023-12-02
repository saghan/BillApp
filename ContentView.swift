//
//  ContentView.swift
//  LiveTextDemo
//
//  Created by Simon Ng on 14/6/2022.
//

import SwiftUI
import VisionKit
import CoreData

struct ContentView: View {
    
    @State private var startScanning = false
    @State private var scanText = ""
    @State private var income: String = ""
    @State private var expense: Float = 0
    @State private var ResetIncome: Bool = false
    @State private var showingSheet = false
    
    init(){
//        print(UserDefaults.standard.bool(forKey: "isIncomeSet"))
        UserDefaults.standard.set(false, forKey: "isIncomeSet")
    }
    
    var body: some View {
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
                        print("income set from 55")
                        UserDefaults.standard.set(true, forKey: "isIncomeSet")
                        UserDefaults.standard.set(income, forKey: "Income")

                    }.buttonStyle(.bordered)
                } //hstack
                HStack{
                    Text("Expense this month:")
                    Text(String(expense))
                    
                }
                Button("Add expense (Bill)", systemImage: "plus"){
                    showingSheet.toggle()

                    
                }.labelStyle(.iconOnly).imageScale(.large)
                    .sheet(isPresented: $showingSheet) {
                        DataScanner(startScanning: $startScanning, scanText: $scanText)
                                        .frame(height: 400)
                                    
                            }.task {
                                                       if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                                                                      startScanning.toggle()
                                                                  }
                                                   }
                
            } //vstack
                .onAppear{
            }
        } //else
    } //body
} //CV
   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
