//
//  DataScannerController.swift
//  LiveTextDemo
//
//  Created by Simon Ng on 14/6/2022.
//

import SwiftUI
import UIKit
import VisionKit
import CoreData

struct DataScanner: UIViewControllerRepresentable {
    @Binding var startScanning: Bool
    @Binding var scanText: String
    @Binding var storeName: String
    @Binding var total: String
    @Binding var date: String
    var dateFormatter = DateFormatter()


    @Binding var touchCount: Int
//    @Binding var receiptImage: Data
    @Binding var save: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Entity.entity(), sortDescriptors: [])
    private var products: FetchedResults<Entity>
    var instruction: String = "xx"
    
        
    func makeUIViewController(context: Context) -> DataScannerViewController {
        dateFormatter.dateFormat = "YY/MM/dd"

        let controller = DataScannerViewController(
                            recognizedDataTypes: [.text()],
                            qualityLevel: .balanced,
                            recognizesMultipleItems: true,
                            isPinchToZoomEnabled: true,
                            isHighlightingEnabled: true
                    
                        )
        
        controller.delegate = context.coordinator
//        addProduct()
        
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context)  {
        
        if startScanning {
            
            try? uiViewController.startScanning()
            if save {
                Task {
                    let photo = try await uiViewController.capturePhoto()
                    let photoPNG = photo.pngData()
                    let product = Entity(context: viewContext)
                    product.billImage = photoPNG
                    product.date = Date.now
                    product.storeName = storeName
                    product.total = total
                    product.date = dateFormatter.date(from: date)
                    saveContext()
                    save=false
                }
                
            } //if save
        } else {
            uiViewController.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func saveContext() {
          do {
              try viewContext.save()
          } catch {
              let error = error as NSError
              fatalError("An error occurred: \(error)")
          }
      }
    
    private func addProduct() {
           withAnimation {
               let product = Entity(context: viewContext)
               saveContext()
           }
       }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScanner
        
        init(_ parent: DataScanner) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                if(parent.touchCount==0){
                    parent.storeName = text.transcript
                }
                if(parent.touchCount==1){
                    parent.total = text.transcript
                }
                parent.touchCount = parent.touchCount+1
            default: break
            }
        }
        
    }
}
