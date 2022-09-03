//
//  ProductDetailView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ProductDetailView: View {
    let productID: Int
    let viewModel: SampleViewModel
    
    @State private var product: Product?
    @EnvironmentObject var errorHandling: ErrorHandling
    
    init(productID: Int, viewModel: SampleViewModel) {
        self.productID = productID
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            if let product {
                VStack(spacing: 20) {
                    AsyncImage(url: product.imageURL,
                               content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 160, maxHeight: 180)},
                               placeholder: {
                        ProgressView()
                            .frame(height: 180)
                    })
                
                    Text(product.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(product.description)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Product ID")
                            Text("\(product.ident)")
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Price")
                            Text(product.priceValue())
                                .fontWeight(.bold)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle(Text(product.category))
            } else {
                ProgressView()
                    .task {
                        do {
                            product = try await viewModel.loadProductDetailFor(productID)
                        } catch {
                            errorHandling.handle(error: error)
                        }
                    }
            }
        }
    }
}
