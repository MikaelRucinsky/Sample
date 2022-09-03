//
//  ProductListView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ProductListView: View {
    
    @State var products = [Product]()
    
    @StateObject private var viewModel = SampleViewModel(environment: URL(string: "https://fakestoreapi.com")!)
    
    var body: some View {
        NavigationView {
            List(products, id: \.ident) { product in
                ProductRowView(product: product)
                    .frame(height: 100)
            }
            .listStyle(.plain)
            .navigationTitle(Text("Products"))
            .toolbar {
                Button("Help") {
                    print("Help tapped!")
                }
            }
        }
        .task {
            do {
                products = try await viewModel.loadProducts()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

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
        
            VStack {
                Text(product.title)
                Text(product.category)
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
