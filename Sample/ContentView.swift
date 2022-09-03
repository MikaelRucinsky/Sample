//
//  ContentView.swift
//  Sample
//
//  Created by rucinsky on 03.09.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = SampleViewModel(environment: URL(string: "https://fakestoreapi.com")!)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let items = try await viewModel.loadProducts()
                print(items)
                
                let item = try await viewModel.loadProductDetailFor(1)
                print(item)
                
                let c = try await viewModel.loadCategories()
                print(c)
                
                let d = try await viewModel.filterByCategory("electronics")
                print(d)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
