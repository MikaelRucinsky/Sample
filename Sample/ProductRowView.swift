//
//  ProductRowView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: product.imageURL,
                       content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 60, maxHeight: 80)},
                       placeholder: {
                ProgressView()
                    .frame(width: 60)
            })
        
            VStack(alignment: .leading) {
                
                Text(product.title)
                    .fontWeight(.bold)
                
                Text(product.category)
            }
        }
    }
}

struct ProductRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProductRowView(product: Product(ident: 1,
                                        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                                        description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                                        category: "men's clothing",
                                        imageURL: URL(string: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg")!,
                                        price: 109.95,
                                        rating: Product.Rating(rate: 3,
                                                               count: 120)))
    }
}
