//
//  ProductListView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ProductListView: View {
    
    @State private var showingCategories = false
    @State private var title = "Products"
    
    @State var products = [Product]()
    @State var categories = [Category]()
    
    @StateObject private var viewModel = SampleViewModel(environment: URL(string: "https://fakestoreapi.com")!)
    
    var body: some View {
        NavigationView {
            List(products, id: \.ident) { product in
                ProductRowView(product: product)
                    .frame(height: 100)
            }
            .listStyle(.plain)
            .navigationTitle(Text(title))
            .toolbar {
                Button("Filter") {
                    Task {
                        do {
                            categories = try await viewModel.loadCategories()
                            showingCategories = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .confirmationDialog("Select category", isPresented: $showingCategories, titleVisibility: .visible) {
                ForEach(categories) { category in
                    Button(category.title) {
                        title = category.title
                        
                        Task {
                            do {
                                products = try await viewModel.filterByCategory(category.title)
                                showingCategories = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
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
        
            VStack(alignment: .leading) {
                
                Text(product.title)
                    .fontWeight(.bold)
                
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
