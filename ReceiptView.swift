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
//    var img: UIImage
//    var date: String
    var product: Entity
    var dateFormatter = DateFormatter()
//    init(){
        
//    }
    var body: some View {
        let _x = dateFormatter.dateFormat = "YY/MM/dd"
        ScrollView([.vertical,.horizontal]) {
            if let unwrappedDate = product.date{
                DisclosureGroup(dateFormatter.string(from: unwrappedDate)){
                    if let unwrappedImage = product.billImage{
                        if let x = UIImage(data: unwrappedImage){
                            Image(uiImage: x).scaleEffect(currentScale).gesture(MagnificationGesture().onChanged { newScale in
                                currentScale = newScale
                            })
                        }
                    }//unwrappedImage
                } //Discols

                
            } //date
                    }
    }
}
//#Preview {
//    ReceiptView()
//}
