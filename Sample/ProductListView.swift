//
//  ProductListView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ProductListView: View {
    
    @State private var title = "Products"
    @State private var showingCategories = false
    @State private var products = [Product]()
    @State private var categories = [Category]()
    
    @StateObject private var viewModel = SampleViewModel(environment: URL(string: "https://fakestoreapi.com")!)
    
    @EnvironmentObject var errorHandling: ErrorHandling
    
    var body: some View {
        NavigationView {
            List(products, id: \.ident) { product in
                NavigationLink {
                    ProductDetailView(productID: product.ident,
                                      viewModel: viewModel)
                } label: {
                    ProductRowView(product: product)
                        .frame(height: 100)
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text(title))
            .toolbar {
                Button("Filter") {
                    Task {
                        do {
                            categories = try await viewModel.loadCategoriesWithFilter(title)
                            showingCategories = true
                        } catch {
                            errorHandling.handle(error: error)
                        }
                    }
                }
            }
            .confirmationDialog("Select category", isPresented: $showingCategories) {
                ForEach(categories) { category in
                    if category.isSelected {
                        Button("Cancel \(category.title)", role: .destructive) {
                            title = "Products"
                            
                            Task {
                                do {
                                    products = try await viewModel.loadProducts()
                                    showingCategories = false
                                } catch {
                                    errorHandling.handle(error: error)
                                }
                            }
                        }
                    } else {
                        Button(category.title) {
                            title = category.title
                            
                            Task {
                                do {
                                    products = try await viewModel.filterByCategory(category.title)
                                    showingCategories = false
                                } catch {
                                    errorHandling.handle(error: error)
                                }
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
                errorHandling.handle(error: error)
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
