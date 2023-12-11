//
//  ReceiptView.swift
//  LiveTextDemo
//
//  Created by Saghan Mudbhari on 12/8/23.
//

import SwiftUI
import PDFKit

struct ReceiptView: View {
    
    @State var currentScale: CGFloat = 1
    @State private var revealDetails = false
    var product: Entity
    var dateFormatter = DateFormatter()
    @State private var showingSheet = false

    var body: some View {
        let _x = dateFormatter.dateFormat = "YY/MM/dd"
        let unwrappedDate = product.date ?? Date.now
        let unwrappedStoreName = product.storeName ?? "Store name not selected from receipt"
        let total = product.total ?? "Total not selected from receipt"
        let buttonLabel = dateFormatter.string(from: unwrappedDate) + "\n" + unwrappedStoreName + "\n" + total
        Button(buttonLabel){
            showingSheet = true
        }.buttonStyle(.bordered)
        .sheet(isPresented: $showingSheet){
            let unwrappedImage = product.billImage ?? Data()
            if let x = UIImage(data: unwrappedImage){
                Image(uiImage: x)
                    .scaleEffect(currentScale).gesture(MagnificationGesture().onChanged { newScale in
                        currentScale = newScale
                    })
            }
        } //sheet
    }
    
}
