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

    var body: some View {
        let _x = dateFormatter.dateFormat = "YY/MM/dd"
        
        ScrollView([.vertical,.horizontal]) {
            var unwrappedDate = product.date ?? Date.now

                DisclosureGroup(content: {
                    var unwrappedImage = product.billImage ?? Data()
                        if let x = UIImage(data: unwrappedImage){
                            Image(uiImage: x).scaleEffect(currentScale).gesture(MagnificationGesture().onChanged { newScale in
                                currentScale = newScale
                            })
                        }
                },
                                label: {
                                    var unwrappedStoreName = product.storeName ?? "Store name not selected from receipt"
                    var total = product.total ?? "Total not selected from receipt"
                    Text(dateFormatter.string(from: unwrappedDate) + "\n" + unwrappedStoreName + "\nTotal: $" + total)
                })
                    }
    }
}
//#Preview {
//    ReceiptView()
//}
